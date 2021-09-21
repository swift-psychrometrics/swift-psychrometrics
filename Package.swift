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
        "Core"
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
        "Density"
      ]
    ),
    .target(
      name: "DewPoint",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "DewPointTests",
      dependencies: [
        "DewPoint"
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
        "Enthalpy"
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
        "HumidityRatio"
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
      dependencies: ["SpecificHumidity"]
    ),
    .target(
      name: "SpecificVolume",
      dependencies: [
        "Core",
        "HumidityRatio",
      ]
    ),
    .testTarget(
      name: "SpecificVolumeTests",
      dependencies: ["SpecificVolume"]
    ),
    .target(
      name: "WetBulb",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "WetBulbTests",
      dependencies: [
        "WetBulb"
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
