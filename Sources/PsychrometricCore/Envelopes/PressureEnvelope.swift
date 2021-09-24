import Foundation

@dynamicMemberLookup
public struct PressureEnvelope<T> {
  
  public var rawValue: Pressure
  
  public init(_ value: Pressure) {
    self.rawValue = value
  }
  
  public subscript<A>(dynamicMember keyPath: KeyPath<Pressure, A>) -> A {
    rawValue[keyPath: keyPath]
  }
}

//extension PressureEnvelope: RawNumericType {
//  public typealias IntegerLiteralType = Pressure.IntegerLiteralType
//  public typealias FloatLiteralType = Pressure.FloatLiteralType
//  public typealias Magnitude = Pressure.Magnitude
//}
