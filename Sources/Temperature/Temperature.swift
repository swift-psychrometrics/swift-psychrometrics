import Foundation

public struct Temperature: Equatable, Hashable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  enum Unit: Equatable, Hashable {
    case celsius(Double)
    case fahrenheit(Double)
    case kelvin(Double)
    case rankine(Double)

    var rawValue: Double {
      switch self {
      case let .fahrenheit(value):
        return value
      case let .celsius(value):
        return value
      case let .rankine(value):
        return value
      case let .kelvin(value):
        return value
      }
    }
  }
}

extension Temperature {

  public static func celsius(_ value: Double) -> Temperature {
    .init(.celsius(value))
  }

  public static func fahrenheit(_ value: Double) -> Temperature {
    .init(.fahrenheit(value))
  }

  public static func kelvin(_ value: Double) -> Temperature {
    .init(.kelvin(value))
  }

  public static func rankine(_ value: Double) -> Temperature {
    .init(.rankine(value))
  }
}

extension Temperature {

  public var celsius: Double {
    get {
      switch unit {
      case let .celsius(celsius):
        return celsius
      case let .fahrenheit(fahrenheit):
        return (fahrenheit - 32) * 5 / 9
      case let .kelvin(kelvin):
        return kelvin - 273.15
      case let .rankine(rankine):
        return (rankine - 491.67) * 5 / 9
      }
    }
    set {
      self.unit = .celsius(newValue)
    }
  }

  public var fahrenheit: Double {
    get {
      switch unit {
      case let .celsius(celsius):
        return celsius * 9 / 5 + 32
      case .fahrenheit(let fahrenheit):
        return fahrenheit
      case let .kelvin(kelvin):
        return kelvin * 9 / 5 - 459.67
      case let .rankine(rankine):
        return rankine - 459.67
      }
    }
    set {
      self.unit = .fahrenheit(newValue)
    }
  }

  public var kelvin: Double {
    get {
      switch unit {
      case .celsius, .rankine:
        return Temperature(.fahrenheit(self.fahrenheit)).kelvin
      case let .fahrenheit(fahrenheit):
        return (fahrenheit + 459.67) * 5 / 9
      case let .kelvin(kelvin):
        return kelvin
      }
    }
    set {
      self.unit = .kelvin(newValue)
    }
  }

  public var rankine: Double {
    get {
      switch unit {
      case .celsius, .kelvin:
        return Temperature(.fahrenheit(self.fahrenheit)).rankine
      case let .fahrenheit(fahrenheit):
        return fahrenheit + 459.67
      case let .rankine(rankine):
        return rankine
      }
    }
    set {
      self.unit = .rankine(newValue)
    }
  }
}

extension Temperature: AdditiveArithmetic {

  public static func - (lhs: Temperature, rhs: Temperature) -> Temperature {
    switch lhs.unit {
    case .celsius(_):
      return .celsius(lhs.celsius - rhs.celsius)
    case .fahrenheit(_):
      return .fahrenheit(lhs.fahrenheit - rhs.fahrenheit)
    case .kelvin(_):
      return .kelvin(lhs.kelvin - rhs.kelvin)
    case .rankine(_):
      return .rankine(lhs.rankine - rhs.rankine)
    }
  }

  public static func + (lhs: Temperature, rhs: Temperature) -> Temperature {
    switch lhs.unit {
    case .celsius(_):
      return .celsius(lhs.celsius + rhs.celsius)
    case .fahrenheit(_):
      return .fahrenheit(lhs.fahrenheit + rhs.fahrenheit)
    case .kelvin(_):
      return .kelvin(lhs.kelvin + rhs.kelvin)
    case .rankine(_):
      return .rankine(lhs.rankine + rhs.rankine)
    }
  }

  public static var zero: Temperature {
    .init(.fahrenheit(0))
  }
}

extension Temperature: Comparable {
  public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
    switch lhs.unit {
    case .celsius(_):
      return lhs.celsius < rhs.celsius
    case .fahrenheit(_):
      return lhs.fahrenheit < rhs.fahrenheit
    case .kelvin(_):
      return lhs.kelvin < rhs.kelvin
    case .rankine(_):
      return lhs.rankine < rhs.rankine
    }
  }
}

extension Temperature: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(.fahrenheit(Double(value)))
  }
}

extension Temperature: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(.fahrenheit(value))
  }
}

extension Temperature: Numeric {

  public init?<T>(exactly source: T) where T: BinaryInteger {
    self.init(floatLiteral: Double(source))
  }

  public var magnitude: Double.Magnitude {
    switch unit {
    case let .celsius(celsius):
      return celsius.magnitude
    case let .fahrenheit(fahrenheit):
      return fahrenheit.magnitude
    case let .kelvin(kelvin):
      return kelvin.magnitude
    case let .rankine(rankine):
      return rankine.magnitude
    }
  }

  public static func * (lhs: Temperature, rhs: Temperature) -> Temperature {
    switch lhs.unit {
    case .celsius(_):
      return .celsius(lhs.celsius * rhs.celsius)
    case .fahrenheit(_):
      return .fahrenheit(lhs.fahrenheit * rhs.fahrenheit)
    case .kelvin(_):
      return .kelvin(lhs.kelvin * rhs.kelvin)
    case .rankine(_):
      return .rankine(lhs.rankine * rhs.rankine)
    }
  }

  public static func *= (lhs: inout Temperature, rhs: Temperature) {
    switch lhs.unit {
    case .celsius(_):
      lhs.unit = .celsius(lhs.celsius * rhs.celsius)
    case .fahrenheit(_):
      lhs.unit = .fahrenheit(lhs.fahrenheit * rhs.fahrenheit)
    case .kelvin(_):
      lhs.unit = .kelvin(lhs.kelvin * rhs.kelvin)
    case .rankine(_):
      lhs.unit = .rankine(lhs.rankine * rhs.rankine)
    }
  }

  public typealias Magnitude = Double.Magnitude
}
