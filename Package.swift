// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TRMosaicLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "TRMosaicLayout", targets: ["TRMosaicLayout"])
    ],
    targets: [
        .target(
            name: "TRMosaicLayout",
            path: "TRMosaicLayout/Classes"
        )
    ]
)
