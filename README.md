[![CI](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml)
[![documentation](https://img.shields.io/badge/Api-Documentation-orange)](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

# swift-psychrometrics

A swift package for calculating properties of moist air, as well as conversions for several different
units of measure.

## Why

Psychrometrics are used by Heating Ventilation and Air Conditioning (HVAC) professionals and engineers, as
well by scientests and metorologists.  This package aims to provide the calculations used for psychrometric
evaluation.  Most of the psychrometric calculations are based off of ASHRAE - Fundamentals (2017).

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

Most of the types this library provides support basic mathematical operations (addition, subtraction,
multiplication, and division).  These operations should for the most part be considered safe, however there
is nothing that prevents a value to be operated on with a different unit of measure, which could lead to
unexpected results.  This library will try to do the right thing and convert the units of measure (taking 
the left hand side of an operation as precedence), but it is encouraged to operate on the underlying raw values
of the type for less error-prone results.

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

- Density:
  - Dry Air
  - Moist Air
  - Water

- Dew Point
  - From temperature and relative humidity
  - From temperature and partial pressure (vapor pressure)
  - From temperature, humidity ratio, and pressure
  
- Enthalpy
  - Dry Air
  - Moist Air

- Grains of Moisture

- Humidity Ratio
  - From water mass and dry air mass
  - From specific humidity
  - From total pressure and partial pressure (vapor pressure)
  - From dry bulb temperature and total pressure
  - From dry bulb temperature, relative humidity, and total pressure
  - From dry bulb temperature, relative humidity, and altitude
  - From dew point temperature and pressure

- Partial Pressure (Vapor Pressure)

- Pressure as function of Altitude

- Relative Humidity
  - From dry bulb temperature and dew point temperature
  - From dry bulb temperature and partial pressure (vapor pressure)

- Saturation Pressure

- Specific Heat (not yet `Numeric` supporting):
  - Water

- Specific Humidity

- Specific Volume
  - Dry Air
  - Moist Air

- Temperature as a function of Altitude

- Total Delivered Heat Quantity

- Wet Bulb

## Documentation

The documentation is currently being worked on / improved with more examples.

[You can view the current api documentation here](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

## License

This project is licensed under the [MIT License](https://github.com/swift-psychrometrics/swift-psychrometrics/LICENSE)

## Contributions

Contributions are welcome.  If errors are found please submit an issue or pull-request.
