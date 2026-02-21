#!/bin/bash
set -e

# ============================================================
# build_xcframework.sh
# Builds a XCFramework from the Rust `libstarwars` project
# using UniFFI, targeting iOS (device + simulator).
# Output lands in iOS/StarWarsLibrary/
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_NAME="starwars"
RUST_DIR="$SCRIPT_DIR/libstarwars"
IOS_DIR="$SCRIPT_DIR/iOS"
SWIFTPM_DIR="$IOS_DIR/StarWarsLibrary"
SOURCES_DIR="$SWIFTPM_DIR/Sources/StarWarsLibrary"
OUTPUT_DIR="$SWIFTPM_DIR/Frameworks"
XCFRAMEWORK_PATH="$OUTPUT_DIR/StarWars.xcframework"

# Rust targets
TARGET_IOS_DEVICE="aarch64-apple-ios"
TARGET_IOS_SIM_ARM="aarch64-apple-ios-sim"
TARGET_IOS_SIM_X86="x86_64-apple-ios"

# ============================================================
# 0. Ensure required Rust targets are installed
# ============================================================
echo "▶ Adding Rust targets..."
rustup target add "$TARGET_IOS_DEVICE"
rustup target add "$TARGET_IOS_SIM_ARM"
rustup target add "$TARGET_IOS_SIM_X86"

# ============================================================
# 1. Build for each target
# ============================================================
echo "▶ Building for iOS device ($TARGET_IOS_DEVICE)..."
cargo build --release --target "$TARGET_IOS_DEVICE" --manifest-path "$RUST_DIR/Cargo.toml"

echo "▶ Building for iOS simulator ARM ($TARGET_IOS_SIM_ARM)..."
cargo build --release --target "$TARGET_IOS_SIM_ARM" --manifest-path "$RUST_DIR/Cargo.toml"

echo "▶ Building for iOS simulator x86_64 ($TARGET_IOS_SIM_X86)..."
cargo build --release --target "$TARGET_IOS_SIM_X86" --manifest-path "$RUST_DIR/Cargo.toml"

# ============================================================
# 2. Lipo simulator slices into a fat library
# ============================================================
echo "▶ Creating fat simulator library..."
SIM_FAT_DIR="$RUST_DIR/target/ios-sim-fat/release"
mkdir -p "$SIM_FAT_DIR"

lipo -create \
  "$RUST_DIR/target/$TARGET_IOS_SIM_ARM/release/lib${LIB_NAME}.a" \
  "$RUST_DIR/target/$TARGET_IOS_SIM_X86/release/lib${LIB_NAME}.a" \
  -output "$SIM_FAT_DIR/lib${LIB_NAME}.a"

# ============================================================
# 3. Generate Swift bindings via UniFFI
# ============================================================
echo "▶ Generating UniFFI Swift bindings..."
mkdir -p "$SOURCES_DIR"

# Use the uniffi-bindgen-main binary baked into the Rust project.
# Must cd into the Rust project dir so cargo metadata resolves correctly.
(cd "$RUST_DIR" && cargo run \
  --bin uniffi-bindgen-main \
  -- \
  generate \
  --library "$RUST_DIR/target/$TARGET_IOS_DEVICE/release/lib${LIB_NAME}.a" \
  --language swift \
  --out-dir "$SOURCES_DIR")

# ============================================================
# 4. Build the .xcframework headers
#    UniFFI emits a <LIB>.modulemap + <LIB>FFI.h; bundle them.
# ============================================================
echo "▶ Packaging headers..."

HEADERS_DIR="$RUST_DIR/target/headers"
mkdir -p "$HEADERS_DIR"

# Move the generated header + modulemap into the headers staging dir
cp "$SOURCES_DIR/"*.h          "$HEADERS_DIR/" 2>/dev/null || true
cp "$SOURCES_DIR/"*.modulemap  "$HEADERS_DIR/" 2>/dev/null || true

# UniFFI names the modulemap after the library; xcodebuild needs it as
# "module.modulemap" inside the headers directory.
MODULEMAP_SRC=$(ls "$HEADERS_DIR/"*.modulemap 2>/dev/null | head -n1)
if [ -n "$MODULEMAP_SRC" ] && [ "$(basename "$MODULEMAP_SRC")" != "module.modulemap" ]; then
  cp "$MODULEMAP_SRC" "$HEADERS_DIR/module.modulemap"
fi

# ============================================================
# 5. Assemble XCFramework
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
# 6. Clean up generated .h / .modulemap from Sources dir
#    (Swift files stay; the headers live inside the XCFramework)
# ============================================================
echo "▶ Cleaning up staging headers from Sources..."
rm -f "$SOURCES_DIR/"*.h
rm -f "$SOURCES_DIR/"*.modulemap

# ============================================================
# Done
# ============================================================
echo ""
echo "✅ XCFramework built successfully!"
echo "   → $XCFRAMEWORK_PATH"
echo ""
echo "   Swift sources (add to Xcode / SwiftPM target):"
echo "   → $SOURCES_DIR"
echo ""
echo "   Add StarWars.xcframework to your Xcode project as a"
echo "   binary target in iOS/StarWarsLibrary/Package.swift."
