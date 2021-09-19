import Foundation

/// Represents / calculates temperature in SI and IP units as well as scientific / absolute units.
public struct Temperature: Equatable, Hashable {

  public static var defaultUnits: Unit = .fahrenheit

  public private(set) var rawValue: Double
  public private(set) var units: Unit

  public init(_ value: Double, units: Unit = Self.defaultUnits) {
    self.rawValue = value
    self.units = units
  }
  
  public subscript(units: Unit) -> Double {
    get { self[keyPath: units.temperatureKeyPath] }
    set { self[keyPath: units.temperatureKeyPath] = newValue }
  }
}

extension Temperature {
  /// Represents the units of measure for a ``Temperature``.
  public enum Unit: String, Equatable, CaseIterable, Codable, Hashable {
    case celsius = "°C"
    case fahrenheit = "°F"
    case kelvin = "°K"
    case rankine = "°R"
    
    public var symbol: String {
      rawValue
    }
    
    public var temperatureKeyPath: WritableKeyPath<Temperature, Double> {
      switch self {
      case .celsius:
        return \.celsius
      case .fahrenheit:
        return \.fahrenheit
      case .kelvin:
        return \.kelvin
      case .rankine:
        return \.rankine
      }
    }
  }
}

extension Temperature {

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The celsius value of the temperature.
  public static func celsius(_ value: Double) -> Temperature {
    .init(value, units: .celsius)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The fahrenheit value of the temperature.
  public static func fahrenheit(_ value: Double) -> Temperature {
    .init(value, units: .fahrenheit)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The kelvin value of the temperature.
  public static func kelvin(_ value: Double) -> Temperature {
    .init(value, units: .kelvin)
  }

  /// Create a new ``Temperature`` with the given value.
  ///
  /// - Parameters:
  ///   - value: The rankine value of the temperature.
  public static func rankine(_ value: Double) -> Temperature {
    .init(value, units: .rankine)
  }
}

extension Temperature {

  /// Access / calculate the temperatre in celsius.
  public var celsius: Double {
    get {
      switch units {
      case .celsius:
        return rawValue
      case .fahrenheit:
        return (rawValue - 32) * 5 / 9
      case .kelvin:
        return rawValue - 273.15
      case .rankine:
        return (rawValue - 491.67) * 5 / 9
      }
    }
    set {
      self = .celsius(newValue)
    }
  }

  /// Access / calculate the temperatre in fahrenheit.
  public var fahrenheit: Double {
    get {
      switch units {
      case .celsius:
        return rawValue * 9 / 5 + 32
      case .fahrenheit:
        return rawValue
      case .kelvin:
        return rawValue * 9 / 5 - 459.67
      case .rankine:
        return rawValue - 459.67
      }
    }
    set {
      self = .fahrenheit(newValue)
    }
  }

  /// Access / calculate the temperatre in kelvin.
  public var kelvin: Double {
    get {
      switch units {
      case .celsius, .rankine:
        return Temperature.fahrenheit(self.fahrenheit).kelvin
      case .fahrenheit:
        return (rawValue + 459.67) * 5 / 9
      case .kelvin:
        return rawValue
      }
    }
    set {
      self = .kelvin(newValue)
    }
  }

  /// Access / calculate the temperatre in rankine.
  public var rankine: Double {
    get {
      switch units {
      case .celsius, .kelvin:
        return Temperature.fahrenheit(self.fahrenheit).rankine
      case .fahrenheit:
        return rawValue + 459.67
      case .rankine:
        return rawValue
      }
    }
    set {
      self = .rankine(newValue)
    }
  }
}

extension Temperature {
  
  func clone(_ newValue: Double) -> Temperature {
    .init(newValue, units: units)
  }
}

// MARK: - Numeric

extension Temperature: AdditiveArithmetic {

  public static func - (lhs: Temperature, rhs: Temperature) -> Temperature {
    lhs.clone(lhs.rawValue - rhs[lhs.units])
  }

  public static func + (lhs: Temperature, rhs: Temperature) -> Temperature {
    lhs.clone(lhs.rawValue + rhs[lhs.units])
  }

  public static var zero: Temperature {
    .init(0)
  }
}

extension Temperature: Comparable {
  public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
    lhs.rawValue < rhs[lhs.units]
  }
}

extension Temperature: Strideable {
  
  public func distance(to other: Temperature) -> Double.Stride {
    rawValue.distance(to: other[keyPath: units.temperatureKeyPath])
  }
  
  public func advanced(by n: Double.Stride) -> Temperature {
    .init(rawValue.advanced(by: n), units: units)
  }
  
  public typealias Stride = Double.Stride
}

extension Temperature: ExpressibleByFloatLiteral {
  
  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension Temperature: FloatingPoint {
  
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    self.rawValue.round(rule)
  }
  
  public init(integerLiteral value: Int) {
    self.init(Double(value))
  }
  
  public init(_ value: Int) {
    self.init(Double(value))
  }
  
  public init<Source>(_ value: Source) where Source : BinaryInteger {
    self.init(Double(value))
  }
  
  public init?<Source>(exactly value: Source) where Source : BinaryInteger {
    self.init(Double(value))
  }
  
  public static func * (lhs: Temperature, rhs: Temperature) -> Temperature {
    lhs.clone(lhs.rawValue * rhs[lhs.units])
  }
  
  public static func *= (lhs: inout Temperature, rhs: Temperature) {
    lhs.rawValue *= rhs[lhs.units]
  }
  
  public var magnitude: Temperature {
    clone(rawValue.magnitude)
  }
  
  public typealias IntegerLiteralType = Int
  
  public init(sign: FloatingPointSign, exponent: Double.Exponent, significand: Temperature) {
    self.init(
      Double(sign: sign, exponent: exponent, significand: significand.rawValue),
      units: significand.units
    )
  }
  
  public init(signOf: Temperature, magnitudeOf: Temperature) {
    self.init(Double.init(signOf: signOf.rawValue, magnitudeOf: magnitudeOf.rawValue))
  }
  
  public static var radix: Int {
    Double.radix
  }
  
  public static var nan: Temperature {
    .init(.nan)
  }
  
  public static var signalingNaN: Temperature {
    .init(.signalingNaN)
  }
  
  public static var infinity: Temperature {
    .init(.infinity)
  }
  
  public static var greatestFiniteMagnitude: Temperature {
    .init(.greatestFiniteMagnitude)
  }
  
  public static var pi: Temperature {
    .init(.pi)
  }
  
  public var ulp: Temperature {
    .init(rawValue.ulp)
  }
  
  public static var leastNormalMagnitude: Temperature {
    .init(.leastNormalMagnitude)
  }
  
  public static var leastNonzeroMagnitude: Temperature {
    .init(.leastNonzeroMagnitude)
  }
  
  public var sign: FloatingPointSign {
    rawValue.sign
  }
  
  public var exponent: Double.Exponent {
    rawValue.exponent
  }
  
  public var significand: Temperature {
    .init(rawValue.significand)
  }
  
  public static func / (lhs: Temperature, rhs: Temperature) -> Temperature {
    lhs.clone(lhs.rawValue / rhs[lhs.units])
  }
  
  public static func /= (lhs: inout Temperature, rhs: Temperature) {
    lhs.rawValue /= rhs[lhs.units]
  }
  
  public static func / (lhs: Temperature, rhs: Double) -> Temperature {
    lhs.clone(lhs.rawValue / rhs)
  }
  
  public static func /= (lhs: inout Temperature, rhs: Double) {
    lhs.rawValue /= rhs
  }
  
  public mutating func formRemainder(dividingBy other: Temperature) {
    self.rawValue.formRemainder(dividingBy: other[keyPath: units.temperatureKeyPath])
  }
  
  public mutating func formTruncatingRemainder(dividingBy other: Temperature) {
    self.rawValue.formTruncatingRemainder(dividingBy: other[keyPath: units.temperatureKeyPath])
  }
  
  public mutating func formSquareRoot() {
    rawValue.formSquareRoot()
  }
  
  public mutating func addProduct(_ lhs: Temperature, _ rhs: Temperature) {
    rawValue.addProduct(lhs.rawValue, rhs[keyPath: lhs.units.temperatureKeyPath])
  }
  
  public var nextUp: Temperature {
    .init(rawValue.nextUp, units: units)
  }
  
  public func isEqual(to other: Temperature) -> Bool {
    self.rawValue == other[keyPath: units.temperatureKeyPath]
  }
  
  public func isLess(than other: Temperature) -> Bool {
    self < other
  }
  
  public func isLessThanOrEqualTo(_ other: Temperature) -> Bool {
    self.rawValue <= other[keyPath: units.temperatureKeyPath]
  }
  
  public func isTotallyOrdered(belowOrEqualTo other: Temperature) -> Bool {
    self.rawValue.isTotallyOrdered(belowOrEqualTo: other[keyPath: units.temperatureKeyPath])
  }
  
  public var isNormal: Bool {
    rawValue.isNormal
  }
  
  public var isFinite: Bool {
    rawValue.isFinite
  }
  
  public var isZero: Bool {
    rawValue.isZero
  }
  
  public var isSubnormal: Bool {
    rawValue.isSubnormal
  }
  
  public var isInfinite: Bool {
    rawValue.isInfinite
  }
  
  public var isNaN: Bool {
    rawValue.isNaN
  }
  
  public var isSignalingNaN: Bool {
    rawValue.isSignalingNaN
  }
  
  public var isCanonical: Bool {
    rawValue.isCanonical
  }
  
  public typealias Exponent = Double.Exponent
}
