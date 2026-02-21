# Star Wars App

A cross-platform Star Wars application built with Rust, SwiftUI, and Kotlin that showcases information about Star Wars films, characters, planets, species, starships, and vehicles.

## Overview

This project demonstrates a modern approach to cross-platform mobile development by sharing core business logic written in Rust across iOS and Android platforms. The Rust library is compiled to native code for each platform using UniFFI, providing a performant and maintainable solution.

## Architecture

The project is organized into three main components:

### 1. **Rust Core Library** (`libstarwars/`)
The heart of the application containing all business logic and API interactions.

- **Language:** Rust
- **Key Dependencies:**
  - UniFFI for language bindings
  - HTTP client for Star Wars API integration
  - Data models for all Star Wars entities

**Main Modules:**
- `api/` - API client and HTTP communication
- `models/` - Data structures for Films, People, Planets, Species, Starships, and Vehicles
- `repository.rs` - Data repository pattern implementation
- `lib.rs` - Library exports and public interface

### 2. **iOS App** (`iOS/`)
Native iOS application built with SwiftUI.

- **Language:** Swift
- **Framework:** SwiftUI
- **Integration:** Uses StarWarsLibrary (compiled Rust library via UniFFI)

**Key Components:**
- `InitialView.swift` - Main entry point
- `Details/` - Detail screens for each entity type
- `Components/` - Reusable UI components (Navigation, SelectableRow, InfoRow)
- `Networking/` - HTTP client for API calls
- `Repository/` - Data repository implementation

### 3. **Android App** (`Android/`)
Native Android application built with Kotlin.

- **Language:** Kotlin
- **Build System:** Gradle (Kotlin DSL)
- **SDK Target:** Compatible with Gradle-based Android build system

**Structure:**
- `app/` - Main application module
- `src/main/` - Source code and resources
- `build.gradle.kts` - Build configuration

## Technologies Used

- **Rust** - Core business logic and API client
- **UniFFI** - Language bindings for iOS and Android
- **SwiftUI** - iOS user interface
- **Kotlin** - Android implementation
- **Gradle** - Android build system
- **Star Wars API** - External data source

## Building the Project

### Prerequisites

- Xcode (for iOS)
- Android Studio (for Android)
- Rust toolchain with targets for iOS and Android
- Swift 5.0+
- Kotlin 1.8+

### Build Script

Use the provided `build.sh` script to automate the build process:

```bash
./build.sh
```

### Building the Rust Library

To rebuild the Rust components:

```bash
cd libstarwars
cargo build --release
```

For iOS:
```bash
cargo build --release --target aarch64-apple-ios
cargo build --release --target aarch64-apple-ios-sim
cargo build --release --target x86_64-apple-ios
```

For Android:
```bash
cargo build --release --target aarch64-linux-android
cargo build --release --target armv7-linux-androideabi
cargo build --release --target x86_64-linux-android
```

## Project Workflow

1. **Data Fetching** - The Rust library fetches data from the Star Wars API
2. **Business Logic** - Core processing and data transformation happens in Rust
3. **Platform UI** - iOS and Android apps display the processed data using native UI frameworks

## File Structure

```
.
├── README.md                 # This file
├── build.sh                  # Build automation script
├── libstarwars/             # Rust library (core logic)
│   ├── Cargo.toml           # Rust dependencies
│   ├── uniffi.toml          # UniFFI configuration
│   └── src/                 # Rust source code
├── iOS/                     # iOS application
│   ├── StarWarsApp/         # Main app source
│   └── StarWarsLibrary/     # UniFFI bindings
└── Android/                 # Android application
    ├── app/                 # Main app module
    └── gradle/              # Gradle configuration
```

## Resources

- [Star Wars API Documentation](https://swapi.dev/)
- [Rust UniFFI Documentation](https://mozilla.github.io/uniffi-rs/)
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)
- [Android Kotlin Documentation](https://developer.android.com/kotlin)
