/// Represents a unit of measure for a container type.
public protocol UnitOfMeasureRepresentable {

  /// The container of the raw values for the unit of measure.
  associatedtype Container

}

/// Represents the default contract for the unit of measures for this library.
public protocol UnitOfMeasure: UnitOfMeasureRepresentable, DefaultRepresentable {}
