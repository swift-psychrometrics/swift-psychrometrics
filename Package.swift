// swift-tools-version:5.4
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  products: [
    .library(name: "CoreUnitTypes", targets: ["CoreUnitTypes"]),
    .library(name: "PsychrometricCore", targets: ["PsychrometricCore"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "CoreUnitTypes"),
    .testTarget(
      name: "CoreTests",
      dependencies: [
        "CoreUnitTypes",
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "DensityTests",
      dependencies: [
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "EnthalpyTests",
      dependencies: [
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "GrainsOfMoistureTests",
      dependencies: [
        "PsychrometricCore"
      ]
    ),
    .testTarget(
      name: "HumidityRatioTests",
      dependencies: [
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
    .target(
      name: "PsychrometricCore",
      dependencies: [
        "CoreUnitTypes"
      ]
    ),
    .testTarget(
      name: "SpecificHeatTests",
      dependencies: ["PsychrometricCore"]
    ),
    .testTarget(
      name: "SpecificHumidityTests",
      dependencies: [
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "SpecificVolumeTests",
      dependencies: [
        "PsychrometricCore",
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
        "PsychrometricCore",
        "TestSupport",
      ]
    ),
  ]
)

// #MARK: - CLI
if #available(macOS 10.15, *),
  ProcessInfo.processInfo.environment["PSYCHROMETRIC_CLI_ENABLED"] != nil
{
  package.platforms = [
    .macOS(.v10_15)
  ]
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.0")
  ])
  package.products.append(contentsOf: [
    .executable(name: "psychrometrics", targets: ["swift-psychrometrics"])
  ])
  package.targets.append(contentsOf: [
    .executableTarget(
      name: "swift-psychrometrics",
      dependencies: [
        "Enthalpy",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    )
  ])
}
