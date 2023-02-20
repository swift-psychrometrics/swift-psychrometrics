import Tagged

// This file holds namespaces for calculations that work on different types.

/// Namespace for calculations that can work on dry air.
public struct Air {}

/// Namespace for calculations that can work on dry air.
public struct DryAir {}
public typealias DryAirEnthalpy = Tagged<DryAir, Enthalpy>
public typealias DryBulb = Tagged<DryAir, Temperature>

/// Namespace for calculations that can work on moist air.
public struct MoistAir {}
public typealias MoistAirEnthalpy = Tagged<MoistAir, Enthalpy>
public typealias WetBulb = Tagged<MoistAir, Temperature>

/// Namespace for calculations that can work on water.
public struct Water {}

public enum Total {}
public typealias TotalPressure = Tagged<Total, Pressure>

public enum Saturation {}
public typealias SaturationPressure = Tagged<Saturation, Pressure>

public enum VaporType {}
public typealias VaporPressure = Tagged<VaporType, Pressure>

public enum DewPointTemperature {}
public typealias DewPoint = Tagged<DewPointTemperature, Temperature>

public enum Specific {}
public typealias SpecificHeat = Tagged<Specific, Temperature>

public enum Relative {}
public typealias RelativeHumidity = Tagged<Relative, Humidity>

public enum Ratio {}
public typealias HumidityRatio = Tagged<Ratio, Humidity>
