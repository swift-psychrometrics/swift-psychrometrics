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
    .library(name: "Length", targets: ["Length"]),
    .library(name: "Pressure", targets: ["Pressure"]),
    .library(name: "SpecificHeat", targets: ["SpecificHeat"]),
    .library(name: "RelativeHumidity", targets: ["RelativeHumidity"]),
    .library(name: "Temperature", targets: ["Temperature"]),
    .library(name: "WetBulb", targets: ["WetBulb"]),
  ],
  dependencies: [
//    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.0")
  ],
  targets: [
    .target(name: "Core"),
    .target(
      name: "Density",
      dependencies: [
        "Pressure",
        "Temperature",
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
        "Core",
        "RelativeHumidity",
        "Temperature",
        "Pressure",
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
        "Pressure",
        "RelativeHumidity",
        "Temperature",
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
        "Core",
        "Length",
        "Pressure",
        "RelativeHumidity",
        "Temperature",
      ]
    ),
    .testTarget(
      name: "GrainsOfMoistureTests",
      dependencies: [
        "GrainsOfMoisture"
      ]
    ),
    .target(
      name: "Length",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "LengthTests",
      dependencies: ["Length"]
    ),
    .target(
      name: "Pressure",
      dependencies: [
        "Core",
        "Length",
        "RelativeHumidity",
        "Temperature",
      ]
    ),
    .testTarget(
      name: "PressureTests",
      dependencies: [
        "Pressure"
      ]
    ),
    .target(
      name: "RelativeHumidity",
      dependencies: [
        "Core",
        "Temperature",
      ]
    ),
    .testTarget(
      name: "RelativeHumidityTests",
      dependencies: [
        "RelativeHumidity"
      ]
    ),
    .target(
      name: "SpecificHeat",
      dependencies: [
        "Temperature"
      ]
    ),
    .testTarget(
      name: "SpecificHeatTests",
      dependencies: ["SpecificHeat"]
    ),
    .target(
      name: "Temperature",
      dependencies: [
        "Core",
        "Length",
      ]
    ),
    .testTarget(
      name: "TemperatureTests",
      dependencies: ["Temperature"]
    ),
    .target(
      name: "WetBulb",
      dependencies: [
        "Core",
        "RelativeHumidity",
        "Temperature",
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
if #available(macOS 10.15, *) {
  package.platforms = [
    .macOS(.v10_15)
  ]
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
        "Enthalpy",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    ),
  ])
}
