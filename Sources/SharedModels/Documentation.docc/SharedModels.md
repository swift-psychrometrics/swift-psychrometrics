# ``SharedModels``

A swift package for performing psychrometric calculations as well as convesions for several different units of measure.

## Overview

Psychrometrics are used by Heating Ventilation and Air Conditioning (HVAC)
professionals and engineers, as well as by scientists and meteorologists.  This package aims to provide the calculations used for psychrometric evaluation.  Most of the calculations are based off of the ASHRAE - Fundamentals (2017).


## Topics

### Base Types

These types are the basic building blocks of a lot of models of this library
and offer conversions to other units of measure commonly used in calculations.
These types generally are all numeric types and support arithmetic operations.

- ``Density``
- ``Enthalpy``
- ``Length``
- ``Humidity``
- ``Pressure``
- ``Temperature``

These types are specialized containers for psychrometric properties. Some of
these types are built on top of the base types and are used to ensure that
the calculations receive / work appropriately. These types generally are 
all numeric types and support arithmetic operations.

### Humidity Types

- ``DegreeOfSaturation``
- ``GrainsOfMoisture``
- ``HumidityRatio``
- ``RelativeHumidity``
- ``SpecificHumidity``

### Pressure Types

- ``SaturationPressure``
- ``TotalPressure``
- ``VaporPressure``

### Temperature Types

- ``DewPoint``
- ``DryBulb``
- ``SpecificHeat``
- ``WetBulb``

### Volume Types

- ``SpecificVolume`` 

### Units of Measure

These define the units of measures for the psychrometric types.

- ``DensityUnits``
- ``EnthalpyUnits``
- ``PressureUnit``
- ``PsychrometricUnits``
- ``SpecificVolumeUnits``
- ``TemperatureUnit``

### Namespace Types

These are types that do not have any properties, but are used as namespaces
and tags for the specialized psychrometric types.

- ``Air``
- ``DewPointTemperature``
- ``DryAir``
- ``MoistAir``
- ``Total``
- ``Saturation``
- ``Specific``
- ``Ratio``
- ``Relative``
- ``VaporType``
- ``Water``

### Namespace Protocols

These types are protocols that conformance is required to be used as types
that can be wrapped in the base types.

- ``DensityType``
- ``EnthalpyType``
- ``HumidityType``
- ``PressureType``
- ``TemperatureType``
