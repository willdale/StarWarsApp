// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StarWarsLibrary",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "StarWarsLibrary",
            targets: ["StarWarsLibrary"]
        )
    ],
    targets: [
        // The main Swift target — contains both the UniFFI-generated
        // bindings and your hand-written Swift source files.
        .target(
            name: "StarWarsLibrary",
            dependencies: ["starwarsFFI"],
            path: "Sources/StarWarsLibrary",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),

        // The XCFramework produced by build_xcframework.sh.
        // Name must match the module name inside the XCFramework exactly.
        .binaryTarget(
            name: "starwarsFFI",
            path: "Frameworks/StarWars.xcframework"
        )
    ],
    swiftLanguageModes: [.v5]
)
