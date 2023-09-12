import Tagged

/// A raw representable type that has a non-failable initializer.
public protocol RawInitializable: RawRepresentable {

  /// Create a concrete instance with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value for the instance.
  init(_ value: RawValue)
}

extension RawInitializable {

  /// - SeeAlso: ``RawRepresentable``
  public init?(rawValue: RawValue) {
    self.init(rawValue)
  }
}

extension Tagged: RawInitializable {
  public init(_ value: RawValue) {
    self.init(rawValue: value)
  }
}
