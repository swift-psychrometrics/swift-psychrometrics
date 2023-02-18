import SharedModels
import Foundation

@dynamicMemberLookup
public struct PressureEnvelope<T> {

  private var _rawValue: Pressure

  public var rawValue: Double {
    _rawValue.rawValue
  }

  public var pressure: Pressure {
    get { _rawValue }
    set { _rawValue = newValue }
  }

  public init(_ value: Pressure) {
    self._rawValue = value
  }

  public init(_ value: Double) {
    self._rawValue = .init(value)
  }

  public init(_ value: Double, units: Pressure.Units) {
    self._rawValue = .init(value, units: units)
  }

  public subscript<A>(dynamicMember keyPath: KeyPath<Pressure, A>) -> A {
    pressure[keyPath: keyPath]
  }
}

extension PressureEnvelope: RawNumericType {
  public typealias IntegerLiteralType = Pressure.IntegerLiteralType
  public typealias FloatLiteralType = Pressure.FloatLiteralType
  public typealias Magnitude = Pressure.Magnitude
}
