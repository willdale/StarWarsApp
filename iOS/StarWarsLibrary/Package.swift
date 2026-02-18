// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "StarWarsLibrary",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "StarWarsLibrary",
            targets: ["StarWarsLibrary"]  // removed trailing comma
        )                                 // removed trailing comma
    ],
    targets: [
        .binaryTarget(
            name: "starwarsFFI",
            path: "StarWars.xcframework"  // removed trailing comma
        ),
        .target(
            name: "StarWarsLibrary",
            dependencies: ["starwarsFFI"],
            path: "Sources/StarWarsLibrary"  // removed trailing comma
        )                                    // removed trailing comma
    ],
    swiftLanguageModes: [.v5]
)
