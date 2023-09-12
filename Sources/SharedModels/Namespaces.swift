import Tagged

// This file holds namespaces for calculations that work on different types.

/// Namespace for calculations that can work on dry air.
public enum Air {}

/// Represents types that can be used in density calculations / conversions.
public protocol DensityType {}

/// Namespace for calculations that can work on dry air.
public enum DryAir: DensityType, EnthalpyType, TemperatureType {}

/// Represents types that can be used in enthalpy calculations / conversions.
public protocol EnthalpyType {}

/// Represents types that can be used in humidity calculations / conversions.
public protocol HumidityType {}

/// Namespace for calculations that can work on moist air.
public enum MoistAir: DensityType, EnthalpyType, TemperatureType {}

/// Represents types that can be used in pressure calculations / conversions.
public protocol PressureType {}

/// Represents types that can be used in temperature calculations / conversions.
public protocol TemperatureType {}

/// Namespace for calculations that can work on water.
public enum Water: DensityType {}

public enum Total: PressureType {}

public enum Saturation: PressureType {}

public enum VaporType: PressureType {}

public enum DewPointTemperature: TemperatureType {}

public enum Specific: TemperatureType {}

public enum Relative: HumidityType {}

public enum Ratio: HumidityType {}
