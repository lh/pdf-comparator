// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PDFComparator",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "PDFComparator",
            targets: ["PDFComparator"]
        )
    ],
    targets: [
        .executableTarget(
            name: "PDFComparator",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        )
    ]
)
