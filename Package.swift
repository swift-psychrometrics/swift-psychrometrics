// swift-tools-version:5.10
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "PsychrometricClient", targets: ["PsychrometricClient"]),
    .library(name: "PsychrometricClientLive", targets: ["PsychrometricClientLive"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "PsychrometricClient",
      dependencies: [
        "SharedModels"
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "PsychrometricClientLive",
      dependencies: [
        "PsychrometricClient"
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "PsychrometricTests",
      dependencies: [
        "PsychrometricClientLive",
        "TestSupport",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged"),
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "SharedModelsTests",
      dependencies: [
        "PsychrometricClientLive",
        "SharedModels",
        "TestSupport",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged"),
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "TestSupport",
      dependencies: [],
      swiftSettings: swiftSettings
    ),
  ]
)

var swiftSettings: [SwiftSetting] {
  [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
  ]
}
