// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextFieldEffects",
    products: [
        .library(name: "TextFieldEffects", targets: ["TextFieldEffects"]),
    ],
    targets: [
        .target(name: "TextFieldEffects", path: "TextFieldEffects/TextFieldEffects")
    ]
)
