import Foundation

/// A container for holding onto degree of saturation values.
public struct DegreeOfSaturation: Equatable, Codable, Sendable, RawInitializable {

  /// The degree of saturation value.
  public var rawValue: Double

  /// Create a new ``DegreeOfSaturation`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The percentage.
  public init(_ value: Double) {
    self.rawValue = value
  }

  public var value: Double { rawValue }
}

extension DegreeOfSaturation: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}
