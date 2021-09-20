public protocol UnitOfMeasure {
  associatedtype Container
  associatedtype Number: NumericType

  var keyPath: WritableKeyPath<Container, Number> { get }
}

public protocol DefaultUnitRepresentable {
  static var `default`: Self { get set }
}
