[![CI](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-psychrometrics/swift-psychrometrics/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/swift-psychrometrics/swift-psychrometrics/branch/main/graph/badge.svg?token=U7W35Y1SXU)](https://codecov.io/gh/swift-psychrometrics/swift-psychrometrics)
[![documentation](https://img.shields.io/badge/Api-Documentation-orange)](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

# swift-psychrometrics

A swift package for calculating properties of moist air, as well as conversions for several different
units of measure.

## Why

Psychrometrics are used by Heating Ventilation and Air Conditioning (HVAC) professionals and engineers, as
well by scientests and metorologists.  This package aims to provide the calculations used for psychrometric
evaluation.  Most of the psychrometric calculations are based off of ASHRAE Fundamentals (2017).
Unit conversions were found either in the ASHRAE Fundamentals or online (primarily at 
  [engineeringtoolbox.com](https://engineeringtoolbox.com)
)

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
  - From temperature and vapor pressure
  
- Enthalpy

- Grains of Moisture

- Humidity Ratio

- Partial Pressure

- Pressure as function of Altitude

- Saturation / Vapor Pressure

- Specific Heat (not yet `Numeric` supporting):
  - Water

- Specific Humidity

- Specific Volume

- Temperature as a function of Altitude

- Total Delivered Heat Quantity

- Wet Bulb

### CLI Utility

This package ships with a command line utility that allows you to explore the different calculations.
It currently does not support all the calculations or units of measure.

To use the command line utility you can use the following command from the project root.
```swift
  PSYCHROMETRIC_CLI_ENABLED=1 swift run psychrometrics
```
Note:
  To use or build the CLI utility you must pass `PSYCHROMETRIC_CLI_ENABLED=1` to the environment of the
  command.

Or to build the command line utility as an executable to put in your `PATH`.  The following command
will build the executable in release mode and open a Finder window at the build location, you can then find
and move the `psychrometrics` executable and put somewhere in your path.
```
make cli
```

### Playground Support

This package ships with an `XCode Playground` in the `Examples` directory that you can use to explore
the API's.

## Documentation

The documentation is currently being worked on / improved with more examples.

[You can view the current api documentation here](https://github.com/swift-psychrometrics/swift-psychrometrics/wiki)

## License

This project is licensed under the [MIT License](https://github.com/swift-psychrometrics/swift-psychrometrics/LICENSE)

## Contributions

Contributions are welcome.  If errors are found please submit an issue or pull-request.
