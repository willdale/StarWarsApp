#!/bin/zsh
set -e

# ============================================================
# build_xcframework.sh
# Builds a XCFramework (iOS) + Android AAR-ready .so libs
# from the Rust `libstarwars` project using UniFFI.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_NAME="starwars"
RUST_DIR="$SCRIPT_DIR/libstarwars"
IOS_DIR="$SCRIPT_DIR/iOS"
SWIFTPM_DIR="$IOS_DIR/StarWarsLibrary"
SOURCES_DIR="$SWIFTPM_DIR/Sources/StarWarsLibrary"
OUTPUT_DIR="$SWIFTPM_DIR/Frameworks"
XCFRAMEWORK_PATH="$OUTPUT_DIR/StarWars.xcframework"

# Android output dirs
ANDROID_DIR="$SCRIPT_DIR/Android/app/src/main"
KOTLIN_SOURCES_DIR="$ANDROID_DIR/java"
ANDROID_JNI_DIR="$ANDROID_DIR/jniLibs"

# Android NDK - must be set in environment or override here
ANDROID_NDK_HOME="$HOME/Library/Android/sdk/ndk/29.0.14206865"
NDK_TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$(uname -s | tr '[:upper:]' '[:lower:]')-x86_64/bin"

# iOS Rust targets
TARGET_IOS_DEVICE="aarch64-apple-ios"
TARGET_IOS_SIM_ARM="aarch64-apple-ios-sim"
TARGET_IOS_SIM_X86="x86_64-apple-ios"

# Android Rust targets and their JNI directory names
typeset -A ANDROID_TARGETS
ANDROID_TARGETS=(
  aarch64-linux-android   arm64-v8a
  armv7-linux-androideabi armeabi-v7a
  i686-linux-android      x86
  x86_64-linux-android    x86_64
)

# ============================================================
# 0. Ensure required Rust targets are installed
# ============================================================
echo "▶ Adding iOS Rust targets..."
rustup target add "$TARGET_IOS_DEVICE" "$TARGET_IOS_SIM_ARM" "$TARGET_IOS_SIM_X86"

echo "▶ Adding Android Rust targets..."
for target in "${(k)ANDROID_TARGETS[@]}"; do
  rustup target add "$target"
done

# ============================================================
# 1. Build iOS targets
# ============================================================
echo "▶ Building for iOS device ($TARGET_IOS_DEVICE)..."
cargo build --release --target "$TARGET_IOS_DEVICE" --manifest-path "$RUST_DIR/Cargo.toml"

echo "▶ Building for iOS simulator ARM ($TARGET_IOS_SIM_ARM)..."
cargo build --release --target "$TARGET_IOS_SIM_ARM" --manifest-path "$RUST_DIR/Cargo.toml"

echo "▶ Building for iOS simulator x86_64 ($TARGET_IOS_SIM_X86)..."
cargo build --release --target "$TARGET_IOS_SIM_X86" --manifest-path "$RUST_DIR/Cargo.toml"

# ============================================================
# 2. Build Android targets
# Each ABI needs its own linker pointed at the NDK clang for
# the correct API level (21 = Android 5.0, raise if needed).
# ============================================================
ANDROID_API=21

echo "▶ Building Android targets..."
for target in "${(k)ANDROID_TARGETS[@]}"; do
  echo "  → $target"

  # Derive the NDK linker name from the target triple
  case "$target" in
    aarch64-linux-android)   NDK_TRIPLE="aarch64-linux-android${ANDROID_API}" ;;
    armv7-linux-androideabi) NDK_TRIPLE="armv7a-linux-androideabi${ANDROID_API}" ;;
    i686-linux-android)      NDK_TRIPLE="i686-linux-android${ANDROID_API}" ;;
    x86_64-linux-android)    NDK_TRIPLE="x86_64-linux-android${ANDROID_API}" ;;
  esac

  CARGO_TARGET_UPPER=$(echo "$target" | tr '[:lower:]-' '[:upper:]_')

  # Pass the NDK linker via env rather than mutating .cargo/config.toml
  env "CARGO_TARGET_${CARGO_TARGET_UPPER}_LINKER=$NDK_TOOLCHAIN/${NDK_TRIPLE}-clang" \
    cargo build --release \
      --target "$target" \
      --manifest-path "$RUST_DIR/Cargo.toml"

  # Copy the .so into the correct jniLibs/<ABI>/ folder
  ABI="${ANDROID_TARGETS[$target]}"
  mkdir -p "$ANDROID_JNI_DIR/$ABI"
  cp "$RUST_DIR/target/$target/release/lib${LIB_NAME}.so" \
     "$ANDROID_JNI_DIR/$ABI/lib${LIB_NAME}.so"
done

# ============================================================
# 3. Lipo iOS simulator slices into a fat library
# ============================================================
echo "▶ Creating fat iOS simulator library..."
SIM_FAT_DIR="$RUST_DIR/target/ios-sim-fat/release"
mkdir -p "$SIM_FAT_DIR"
lipo -create \
  "$RUST_DIR/target/$TARGET_IOS_SIM_ARM/release/lib${LIB_NAME}.a" \
  "$RUST_DIR/target/$TARGET_IOS_SIM_X86/release/lib${LIB_NAME}.a" \
  -output "$SIM_FAT_DIR/lib${LIB_NAME}.a"

# ============================================================
# 4. Generate Swift bindings (iOS)
# ============================================================
echo "▶ Generating UniFFI Swift bindings..."
mkdir -p "$SOURCES_DIR"

(cd "$RUST_DIR" && cargo run \
  --bin uniffi-bindgen-main \
  -- generate \
  --library "$RUST_DIR/target/$TARGET_IOS_DEVICE/release/lib${LIB_NAME}.a" \
  --language swift \
  --out-dir "$SOURCES_DIR")

# ============================================================
# 5. Generate Kotlin bindings (Android)
# Uses one of the Android .so files as the source of truth.
# ============================================================
echo "▶ Generating UniFFI Kotlin bindings..."
mkdir -p "$KOTLIN_SOURCES_DIR"

ANDROID_LIB_FOR_BINDGEN="$RUST_DIR/target/aarch64-linux-android/release/lib${LIB_NAME}.so"

(cd "$RUST_DIR" && cargo run \
  --bin uniffi-bindgen-main \
  -- generate \
  --library "$ANDROID_LIB_FOR_BINDGEN" \
  --language kotlin \
  --out-dir "$KOTLIN_SOURCES_DIR")

# ============================================================
# 6. Package iOS headers for XCFramework
# ============================================================
echo "▶ Packaging iOS headers..."
HEADERS_DIR="$RUST_DIR/target/headers"
mkdir -p "$HEADERS_DIR"
cp "$SOURCES_DIR/"*.h         "$HEADERS_DIR/" 2>/dev/null || true
cp "$SOURCES_DIR/"*.modulemap "$HEADERS_DIR/" 2>/dev/null || true

MODULEMAP_SRC=$(ls "$HEADERS_DIR/"*.modulemap 2>/dev/null | head -n1)
if [ -n "$MODULEMAP_SRC" ] && [ "$(basename "$MODULEMAP_SRC")" != "module.modulemap" ]; then
  cp "$MODULEMAP_SRC" "$HEADERS_DIR/module.modulemap"
fi

# ============================================================
# 7. Assemble XCFramework
# ============================================================
echo "▶ Assembling XCFramework..."
mkdir -p "$OUTPUT_DIR"
rm -rf "$XCFRAMEWORK_PATH"

xcodebuild -create-xcframework \
  -library "$RUST_DIR/target/$TARGET_IOS_DEVICE/release/lib${LIB_NAME}.a" \
    -headers "$HEADERS_DIR" \
  -library "$SIM_FAT_DIR/lib${LIB_NAME}.a" \
    -headers "$HEADERS_DIR" \
  -output "$XCFRAMEWORK_PATH"

# ============================================================
# 8. Clean staging headers from Swift Sources dir
# ============================================================
echo "▶ Cleaning up staging headers from Sources..."
rm -f "$SOURCES_DIR/"*.h
rm -f "$SOURCES_DIR/"*.modulemap

# ============================================================
# Done
# ============================================================
echo ""
echo "✅ Build complete!"
echo ""
echo "iOS:"
echo "   XCFramework  → $XCFRAMEWORK_PATH"
echo "   Swift sources → $SOURCES_DIR"
echo ""
echo "Android:"
echo "   Kotlin sources → $KOTLIN_SOURCES_DIR"
echo "   JNI libs       → $ANDROID_JNI_DIR"
echo ""
echo "Wire up the Android module by adding the jniLibs dir and"
echo "the generated Kotlin sources to your Gradle build."
