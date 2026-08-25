// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Dragon-Medical-SpeechKit-iOS",
    defaultLocalization: "en",
    products: [
        .library(
            name: "Dragon-Medical-SpeechKit-iOS",
            targets: ["Bundle", "DragonMedicalSpeechKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/microsoft/speech-sdk-spm", from: "1.51.0")
    ],
    targets: [
        .target(
            name: "Bundle",
            dependencies: [
                .product(name: "MicrosoftCognitiveServicesSpeechEmbedded-iOS", package: "speech-sdk-spm")
            ],
            path: "Sources/SDK",
            resources: [
                .process("Bundle/Resources"),
                .copy("Bundle/UI/Correction.storyboardc")
            ]
        ),
        .binaryTarget(
            name: "DragonMedicalSpeechKit",
            path: "Sources/SDK/DragonMedicalSpeechKit.xcframework"
        )
    ]
)

//
