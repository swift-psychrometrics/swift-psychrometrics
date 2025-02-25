import Tagged

// This file holds namespaces for calculations that work on different types.

/// Represents types that can be used in density calculations / conversions.
public protocol DensityType: Sendable {}

/// Represents types that can be used in enthalpy calculations / conversions.
public protocol EnthalpyType: Sendable {}

/// Represents types that can be used in humidity calculations / conversions.
public protocol HumidityType: Sendable {}

/// Represents types that can be used in pressure calculations / conversions.
public protocol PressureType: Sendable {}

/// Represents types that can be used in temperature calculations / conversions.
public protocol TemperatureType: Sendable {}

/// A namespace for dew point temperature types.
public enum DewPointTemperature: TemperatureType, Sendable {}

/// Namespace for calculations that can work on dry air.
public enum DryAir: DensityType, EnthalpyType, TemperatureType {}

/// Namespace for calculations that can work on moist air.
public enum MoistAir: DensityType, EnthalpyType, TemperatureType {}

/// A namespace for relative humidity types.
public enum Relative: HumidityType {}

/// A namespace for humidity ratio.
public enum Ratio: HumidityType {}

/// A namespace for saturation pressure.
public enum Saturation: PressureType {}

/// A namespace for specific heat type.
public enum Specific: TemperatureType {}

/// A namespace for total pressure.
public enum Total: PressureType {}

/// A namespace for vapor pressure.
public enum VaporType: PressureType {}

/// Namespace for calculations that can work on water.
public enum Water: DensityType {}
