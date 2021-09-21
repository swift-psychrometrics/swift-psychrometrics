/// Represents a type that can give a default value for itself.
public protocol DefaultRepresentable {

  /// The default value to use for the type.
  static var `default`: Self { get set }
}
