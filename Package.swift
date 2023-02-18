// swift-tools-version:5.4
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "CoreUnitTypes", targets: ["CoreUnitTypes"]),
    .library(name: "PsychrometricEnvironment", targets: ["PsychrometricEnvironment"]),
    .library(name: "Psychrometrics", targets: ["Psychrometrics"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "CoreUnitTypes",
      dependencies: []
    ),
    .testTarget(
      name: "CoreTests",
      dependencies: [
        "CoreUnitTypes",
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "DensityTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "DewPointTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "EnthalpyTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "GrainsOfMoistureTests",
      dependencies: [
        "Psychrometrics"
      ]
    ),
    .testTarget(
      name: "HumidityRatioTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "PsychrometricEnvironment",
      dependencies: [
        "CoreUnitTypes",
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .target(
      name: "Psychrometrics",
      dependencies: [
        "CoreUnitTypes",
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
    .testTarget(
      name: "SpecificHeatTests",
      dependencies: [
        "Psychrometrics"
      ]
    ),
    .testTarget(
      name: "SpecificHumidityTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "SpecificVolumeTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "TestSupport",
      dependencies: []
    ),
    .testTarget(
      name: "WetBulbTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
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
    .library(name: "CLICore", targets: ["CLICore"]),
    .executable(name: "psychrometrics", targets: ["swift-psychrometrics"]),
  ])
  package.targets.append(contentsOf: [
    .target(
      name: "CLICore",
      dependencies: [
        "Psychrometrics",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    ),
    .executableTarget(
      name: "swift-psychrometrics",
      dependencies: [
        "Psychrometrics",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    ),
  ])
}
