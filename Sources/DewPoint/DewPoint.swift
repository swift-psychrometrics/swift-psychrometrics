import Core
import Foundation
import HumidityRatio

/// Represents / calculates the dew-point.
@dynamicMemberLookup
public struct DewPoint {

  /// The raw dew point temperature.
  public var rawValue: Temperature

  /// Creates a new ``DewPoint`` as the temperaure given.
  ///
  /// - Parameters:
  ///   - temperature: The dew-point temperature to set on the instance.
  public init(_ value: Temperature) {
    self.rawValue = value
  }

  /// Access values on the wrapped temperature.
  public subscript<V>(dynamicMember keyPath: KeyPath<Temperature, V>) -> V {
    rawValue[keyPath: keyPath]
  }
}


extension DewPoint: RawNumericType {
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature.Magnitude
}
