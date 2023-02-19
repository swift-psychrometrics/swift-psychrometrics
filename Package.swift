// swift-tools-version:5.4
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "PsychrometricEnvironment", targets: ["PsychrometricEnvironment"]),
    .library(name: "Psychrometrics", targets: ["Psychrometrics"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
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
        "SharedModels",
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "PsychrometricEnvironment",
      dependencies: [
        "SharedModels",
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .target(
      name: "Psychrometrics",
      dependencies: [
        "SharedModels",
        "PsychrometricEnvironment",
      ]
    ),
    .testTarget(
      name: "PsychrometricTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "TestSupport",
      dependencies: []
    ),
  ]
)

// #MARK: - CLI
if #available(macOS 10.15, *),
  ProcessInfo.processInfo.environment["PSYCHROMETRIC_CLI_ENABLED"] != nil
{
//  package.platforms = [
//    .macOS(.v10_15)
//  ]
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.0")
  ])
  package.products.append(contentsOf: [
    .executable(name: "psychrometrics", targets: ["swift-psychrometrics"]),
  ])
  package.targets.append(contentsOf: [
    .executableTarget(
      name: "swift-psychrometrics",
      dependencies: [
        "Psychrometrics",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    ),
  ])
}
