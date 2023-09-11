import Tagged

// This file holds namespaces for calculations that work on different types.

/// Namespace for calculations that can work on dry air.
public struct Air {}

/// Represents types that can be used in density calculations / conversions.
public protocol DensityType { }

/// Namespace for calculations that can work on dry air.
public struct DryAir: DensityType {}

/// Namespace for calculations that can work on moist air.
public struct MoistAir: DensityType {}

/// Namespace for calculations that can work on water.
public struct Water: DensityType {}

public enum Total {}

public enum Saturation {}

public enum VaporType {}

public enum DewPointTemperature {}

public enum Specific {}

public enum Relative {}

public enum Ratio {}
