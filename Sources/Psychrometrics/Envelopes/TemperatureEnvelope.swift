import SharedModels
import Foundation

@dynamicMemberLookup
public struct TemperatureEnvelope<T> {

  private var _rawValue: Temperature

  public var rawValue: Double {
    _rawValue.rawValue
  }

  public var temperature: Temperature {
    get { _rawValue }
    set { _rawValue = newValue }
  }

  public init(temperature: Temperature) {
    self._rawValue = temperature
  }

  public init(_ value: Double) {
    self._rawValue = .init(value)
  }

  public init(_ value: Double, units: Temperature.Units) {
    self._rawValue = .init(value, units: units)
  }

  public subscript<A>(dynamicMember keyPath: KeyPath<Temperature, A>) -> A {
    temperature[keyPath: keyPath]
  }
}

extension TemperatureEnvelope: RawNumericType {
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature.Magnitude
}
