import Foundation

@dynamicMemberLookup
public struct TemperatureEnvelope<T> {
  
  public var rawValue: Temperature
  
  public init(_ value: Temperature) {
    self.rawValue = value
  }
  
  public subscript<A>(dynamicMember keyPath: KeyPath<Temperature, A>) -> A {
    rawValue[keyPath: keyPath]
  }
}

//extension PressureEnvelope: RawNumericType {
//  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
//  public typealias FloatLiteralType = Temperature.FloatLiteralType
//  public typealias Magnitude = Temperature.Magnitude
//}
