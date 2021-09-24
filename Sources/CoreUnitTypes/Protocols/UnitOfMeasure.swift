/// Represents the default contract for the unit of measures for this library.
public protocol UnitOfMeasure {

  static func defaultFor(units: PsychrometricEnvironment.Units) -> Self
}
