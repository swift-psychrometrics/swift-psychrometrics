// swift-tools-version:5.7
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  platforms: [
    .macOS(.v12),
      .iOS(.v15)
  ],
  products: [
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "PsychrometricClient", targets: ["PsychrometricClient"]),
    .library(name: "PsychrometricClientLive", targets: ["PsychrometricClientLive"]),
    .library(name: "PsychrometricEnvironment", targets: ["PsychrometricEnvironment"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-dependencies",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-tagged",
      from: "0.10.0"
    ),
  ],
  targets: [
    .target(
      name: "SharedModels",
      dependencies: [
        .product(name: "Tagged", package: "swift-tagged")
      ]
    ),
    .testTarget(
      name: "SharedModelsTests",
      dependencies: [
        "PsychrometricClientLive",
        "SharedModels",
        "TestSupport",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged")
      ]
    ),
    .target(
      name: "PsychrometricEnvironment",
      dependencies: [
        "SharedModels",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "PsychrometricClient",
      dependencies: [
        "SharedModels",
        "PsychrometricEnvironment",
      ]
    ),
    .target(
      name: "PsychrometricClientLive",
      dependencies: [
        "PsychrometricClient",
        "PsychrometricEnvironment",
      ]
    ),
    .testTarget(
      name: "PsychrometricTests",
      dependencies: [
        "PsychrometricClientLive",
        "TestSupport",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Tagged", package: "swift-tagged")
      ]
    ),
    .target(
      name: "TestSupport",
      dependencies: []
    ),
  ]
)
