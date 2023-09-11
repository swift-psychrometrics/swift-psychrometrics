import Tagged

// This file holds namespaces for calculations that work on different types.

/// Namespace for calculations that can work on dry air.
public struct Air {}

/// Represents types that can be used in density calculations / conversions.
public protocol DensityType {}

/// Namespace for calculations that can work on dry air.
public struct DryAir: DensityType, EnthalpyType, TemperatureType {}

/// Represents types that can be used in enthalpy calculations / conversions.
public protocol EnthalpyType {}

/// Represents types that can be used in humidity calculations / conversions.
public protocol HumidityType {}

/// Namespace for calculations that can work on moist air.
public struct MoistAir: DensityType, EnthalpyType, TemperatureType {}

/// Represents types that can be used in temperature calculations / conversions.
public protocol TemperatureType {}

/// Namespace for calculations that can work on water.
public struct Water: DensityType {}

public enum Total {}

public enum Saturation {}

public enum VaporType {}

public enum DewPointTemperature: TemperatureType {}

public enum Specific: TemperatureType {}

public enum Relative: HumidityType {}

public enum Ratio: HumidityType {}
