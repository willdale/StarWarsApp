#!/bin/bash

# Build script for uniffi-bindgen-swift
# This script automates building Rust libraries and generating Swift bindings

set -e  # Exit on error

# Configuration
LIBRARY_NAME="starwars"
MODULE_NAME="StarWars"
IOS_DEPLOYMENT_TARGET="18.0"
BUILD_DIR="build"
BINDINGS_DIR="${BUILD_DIR}/bindings"
XCFRAMEWORK_NAME="${MODULE_NAME}.xcframework"

# SPM Configuration
SPM_PACKAGE_DIR="../iOS/StarwarsLibrary"
SPM_SOURCES_DIR="${SPM_PACKAGE_DIR}/Sources/StarwarsLibrary"
SPM_XCFRAMEWORK_DIR="${SPM_PACKAGE_DIR}"

# Set iOS deployment target environment variable
export IPHONEOS_DEPLOYMENT_TARGET="${IOS_DEPLOYMENT_TARGET}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
    exit 1
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_step "Checking requirements..."
    
    if ! command -v cargo &> /dev/null; then
        print_error "cargo is not installed. Please install Rust from https://rustup.rs"
    fi
    
    if ! command -v xcodebuild &> /dev/null; then
        print_error "xcodebuild is not installed. Please install Xcode."
    fi
    
    echo "✓ All requirements met"
    echo "✓ iOS Deployment Target: ${IOS_DEPLOYMENT_TARGET}"
}

# Add iOS targets
add_ios_targets() {
    print_step "Adding iOS targets..."
    
    rustup target add aarch64-apple-ios 2>/dev/null || echo "✓ aarch64-apple-ios already installed"
    rustup target add aarch64-apple-ios-sim 2>/dev/null || echo "✓ aarch64-apple-ios-sim already installed"
    rustup target add x86_64-apple-ios 2>/dev/null || echo "✓ x86_64-apple-ios already installed"
}

# Build Rust library for all iOS targets
build_rust() {
    print_step "Building Rust library..."
    
    # Build for iOS device (ARM64)
    print_step "Building for iOS device (aarch64-apple-ios)..."
    cargo build --release --target aarch64-apple-ios
    
    # Build for iOS simulator (ARM64)
    print_step "Building for iOS simulator (aarch64-apple-ios-sim)..."
    cargo build --release --target aarch64-apple-ios-sim
    
    # Build for iOS simulator (x86_64)
    print_step "Building for iOS simulator (x86_64-apple-ios)..."
    cargo build --release --target x86_64-apple-ios
    
    echo "✓ Rust library built for all targets"
}

# Create fat library for simulator (combining x86_64 and aarch64)
create_simulator_fat_library() {
    print_step "Creating universal simulator library..."
    
    mkdir -p target/universal-ios-sim/release
    
    lipo -create \
        target/x86_64-apple-ios/release/lib${LIBRARY_NAME}.a \
        target/aarch64-apple-ios-sim/release/lib${LIBRARY_NAME}.a \
        -output target/universal-ios-sim/release/lib${LIBRARY_NAME}.a
    
    echo "✓ Universal simulator library created"
}

# Generate Swift bindings
generate_bindings() {
    print_step "Generating Swift bindings..."
    
    # Clean and create bindings directory
    rm -rf ${BINDINGS_DIR}
    mkdir -p ${BINDINGS_DIR}
    
    # Use the iOS device library for binding generation
    LIBRARY_PATH="target/aarch64-apple-ios/release/lib${LIBRARY_NAME}.a"
    
    if [ ! -f "$LIBRARY_PATH" ]; then
        print_error "Library not found at $LIBRARY_PATH. Build the Rust library first."
    fi
    
    # Generate Swift sources
    print_step "Generating Swift source files..."
    cargo run --bin uniffi-bindgen-swift -- \
        ${LIBRARY_PATH} \
        ${BINDINGS_DIR} \
        --swift-sources
    
    # Generate headers
    print_step "Generating header files..."
    cargo run --bin uniffi-bindgen-swift -- \
        ${LIBRARY_PATH} \
        ${BINDINGS_DIR} \
        --headers
    
    # Generate modulemap
    print_step "Generating modulemap..."
    cargo run --bin uniffi-bindgen-swift -- \
        ${LIBRARY_PATH} \
        ${BINDINGS_DIR} \
        --modulemap \
        --modulemap-filename module.modulemap
    
    # Fix module name in modulemap to match Swift import
    print_step "Fixing module name in modulemap..."
    if [ -f "${BINDINGS_DIR}/module.modulemap" ]; then
        # Read the current module name and replace with starwarsFFI
        sed -i '' 's/module [a-zA-Z0-9_]*/module starwarsFFI/' "${BINDINGS_DIR}/module.modulemap"
        echo "✓ Module name set to starwarsFFI"
    fi
    
    echo "✓ Swift bindings generated"
}

# Create XCFramework
create_xcframework() {
    print_step "Creating XCFramework..."
    
    # Remove existing XCFramework
    rm -rf ${BUILD_DIR}/${XCFRAMEWORK_NAME}
    
    # Create XCFramework
    xcodebuild -create-xcframework \
        -library target/aarch64-apple-ios/release/lib${LIBRARY_NAME}.a \
        -headers ${BINDINGS_DIR} \
        -library target/universal-ios-sim/release/lib${LIBRARY_NAME}.a \
        -headers ${BINDINGS_DIR} \
        -output ${BUILD_DIR}/${XCFRAMEWORK_NAME}
    
    echo "✓ XCFramework created at ${BUILD_DIR}/${XCFRAMEWORK_NAME}"
}

# Copy Swift files for easy access
copy_swift_files() {
    print_step "Organizing Swift files..."
    
    # Find and copy Swift files to a dedicated directory
    mkdir -p ${BUILD_DIR}/swift-sources
    find ${BINDINGS_DIR} -name "*.swift" -exec cp {} ${BUILD_DIR}/swift-sources/ \;
    
    echo "✓ Swift source files copied to ${BUILD_DIR}/swift-sources/"
}

# Copy to SPM package
copy_to_spm_package() {
    print_step "Copying artifacts to Swift Package..."
    
    # Check if SPM package directory exists
    if [ ! -d "${SPM_PACKAGE_DIR}" ]; then
        print_warning "SPM package directory not found at ${SPM_PACKAGE_DIR}"
        print_warning "Skipping SPM integration. Please create the package manually."
        return
    fi
    
    # Create Sources directory if it doesn't exist
    mkdir -p "${SPM_SOURCES_DIR}"
    
    # Copy XCFramework to package root
    print_step "Copying XCFramework to ${SPM_XCFRAMEWORK_DIR}/${XCFRAMEWORK_NAME}..."
    rm -rf "${SPM_XCFRAMEWORK_DIR}/${XCFRAMEWORK_NAME}"
    cp -R "${BUILD_DIR}/${XCFRAMEWORK_NAME}" "${SPM_XCFRAMEWORK_DIR}/"
    
    # Copy Swift source files to Sources directory
    print_step "Copying Swift sources to ${SPM_SOURCES_DIR}..."
    find ${BUILD_DIR}/swift-sources -name "*.swift" -exec cp {} ${SPM_SOURCES_DIR}/ \;
    
    echo "✓ Artifacts copied to Swift Package"
    echo "  - XCFramework: ${SPM_XCFRAMEWORK_DIR}/${XCFRAMEWORK_NAME}"
    echo "  - Swift sources: ${SPM_SOURCES_DIR}/"
}

# Main build process
main() {
    echo "========================================="
    echo "  UniFFI Swift Bindings Build Script"
    echo "========================================="
    echo ""
    
    check_requirements
    add_ios_targets
    build_rust
    create_simulator_fat_library
    generate_bindings
    create_xcframework
    copy_swift_files
    copy_to_spm_package
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}  Build completed successfully!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Build artifacts:"
    echo "  - XCFramework: ${BUILD_DIR}/${XCFRAMEWORK_NAME}"
    echo "  - Swift sources: ${BUILD_DIR}/swift-sources/"
    echo ""
    echo "Swift Package:"
    echo "  - Package location: ${SPM_PACKAGE_DIR}"
    echo "  - XCFramework: ${SPM_XCFRAMEWORK_DIR}/${XCFRAMEWORK_NAME}"
    echo "  - Sources: ${SPM_SOURCES_DIR}/"
    echo ""
}

# Run main function
main
