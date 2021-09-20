// swift-tools-version:5.4

import PackageDescription

let package = Package(
  name: "swift-psychrometrics",
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
  dependencies: [],
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
        "Temperature"
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
      dependencies: ["Core"]
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
