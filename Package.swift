// swift-tools-version:5.4
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  //  platforms: [
  //    .macOS(.v10_15),
  //    .iOS(.v10),
  //  ],
  products: [
    .library(name: "Core", targets: ["Core"]),
    .library(name: "Density", targets: ["Density"]),
    .library(name: "DewPoint", targets: ["DewPoint"]),
    .library(name: "Enthalpy", targets: ["Enthalpy"]),
    .library(name: "GrainsOfMoisture", targets: ["GrainsOfMoisture"]),
    .library(name: "HumidityRatio", targets: ["HumidityRatio"]),
    .library(name: "SpecificHeat", targets: ["SpecificHeat"]),
    .library(name: "SpecificHumidity", targets: ["SpecificHumidity"]),
    .library(name: "SpecificVolume", targets: ["SpecificVolume"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
    .library(name: "WetBulb", targets: ["WetBulb"]),
  ],
  dependencies: [
    //    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.0")
  ],
  targets: [
    .target(name: "Core"),
    .testTarget(
      name: "CoreTests",
      dependencies: [
        "Core",
        "TestSupport",
      ]
    ),
    .target(
      name: "Density",
      dependencies: [
        "Core",
        "HumidityRatio",
        "SpecificVolume",
      ]
    ),
    .testTarget(
      name: "DensityTests",
      dependencies: [
        "Density",
        "TestSupport",
      ]
    ),
    .target(
      name: "DewPoint",
      dependencies: [
        "Core",
        "HumidityRatio",
      ]
    ),
    .testTarget(
      name: "DewPointTests",
      dependencies: [
        "DewPoint",
        "TestSupport",
      ]
    ),
    .target(
      name: "Enthalpy",
      dependencies: [
        "Core",
        "HumidityRatio",
      ]
    ),
    .testTarget(
      name: "EnthalpyTests",
      dependencies: [
        "Enthalpy",
        "TestSupport",
      ]
    ),
    .target(
      name: "GrainsOfMoisture",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "GrainsOfMoistureTests",
      dependencies: [
        "GrainsOfMoisture"
      ]
    ),
    .target(
      name: "HumidityRatio",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "HumidityRatioTests",
      dependencies: [
        "HumidityRatio",
        "TestSupport",
      ]
    ),
    .target(
      name: "SpecificHeat",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "SpecificHeatTests",
      dependencies: ["SpecificHeat"]
    ),
    .target(
      name: "SpecificHumidity",
      dependencies: [
        "Core",
        "HumidityRatio",
      ]
    ),
    .testTarget(
      name: "SpecificHumidityTests",
      dependencies: [
        "SpecificHumidity",
        "TestSupport",
      ]
    ),
    .target(
      name: "SpecificVolume",
      dependencies: [
        "Core",
        "HumidityRatio",
        "TestSupport",
      ]
    ),
    .testTarget(
      name: "SpecificVolumeTests",
      dependencies: ["SpecificVolume"]
    ),
    .target(name: "TestSupport"),
    .target(
      name: "WetBulb",
      dependencies: [
        "Core",
        "DewPoint",
        "HumidityRatio",
      ]
    ),
    .testTarget(
      name: "WetBulbTests",
      dependencies: [
        "WetBulb",
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
