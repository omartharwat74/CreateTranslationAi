// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreateTranslationAi",
    defaultLocalization: "ar",
    platforms: [
        .iOS(.v16),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CreateTranslationAi",
            targets: ["CreateTranslationAi"]),
    ],
    targets: [
        .target(
            name: "CreateTranslationAi",
            resources: [
                .copy("TranslateCell.xib"),
                .copy("Fonts/DINNextLTArabic-Bold-4.ttf"),
                .copy("DINNextLTArabic-Medium-4.ttf"),
                .copy("DINNextLTArabic-Regular-3.ttf"),
                .process("Resources")
            ]
        ),
    ]
)
