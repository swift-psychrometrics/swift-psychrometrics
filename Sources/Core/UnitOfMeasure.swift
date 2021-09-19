
public protocol UnitOfMeasure {
  associatedtype Container
  var keyPath: WritableKeyPath<Container, Double> { get }
}

public protocol DefaultUnitRepresentable {
  static var `default`: Self { get set }
}
