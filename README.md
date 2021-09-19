[![CI](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/swift-psychrometrics/swift-psychrometrics/branch/main/graph/badge.svg?token=U7W35Y1SXU)](https://codecov.io/gh/swift-psychrometrics/swift-psychrometrics)
[![documentation](https://img.shields.io/badge/Api-Documentation-orange)](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

# swift-psychrometrics

A swift package for calculating properties of moist air, as well as conversions for several different
units of measure.

## Why

Psychrometrics are used by Heating Ventilation and Air Conditioning (HVAC) professionals and engineers, as
well by scientests and metorologists.  This package aims to provide the calculations used for psychrometric
evaluation.

## Installation

Include in your project using swift package manager.
```swift
let package = Package(
  ...
  dependencies: [
    .package(url: "https://github.com/swift-psychrometrics/swift-psychrometrics.git", from: "0.1.0")
  ],
  ...
)
```

## Getting Started

This package provides several libraries depending on your needs.  There are basic units of measure that are
convertible to other standard units of measure, including S.I. and I.P. units.  As well as calculations for
moist and dry air conditions, and a few calculations for water.

### Units of Measure
The following units of measure are provided with the corresponding conversions.

- Temperature:
  - Fahrenheit
  - Celsius
  - Rankine
  - Kelvin
  
- Length:
  - Feet
  - Inches
  - Meters
  - Centimeters
  
- Pressure:
  - Atmosphere
  - Bar
  - Inches of Water Column
  - Millibar
  - Pascals
  - PSIG
  - Torr
  
- Relative Humidity

### Calculations

The following calculations are currently provided.  Most of these types are `Numeric` and support arithmetic.
Some of these calculations do not yet support different units of measure.

- Density (not yet `Numeric` supporting):
  - Dry Air
  - Water
  
- Enthalpy

- Grains of Moisture

- Specific Heat (not yet `Numeric` supporting):
  - Water

- Wet Bulb

## Documentation

The documentation is currently being worked on / improved with more examples.

[You can view the current api documentation here](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

## License

This project is licensed under the [MIT License](https://github.com/swift-psychrometrics/swift-psychrometrics/LICENSE)
