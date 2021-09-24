/// Represents a unit of measure for a container type.
public protocol UnitOfMeasureRepresentable {}

/// Represents the default contract for the unit of measures for this library.
public protocol UnitOfMeasure: UnitOfMeasureRepresentable, DefaultRepresentable {}
