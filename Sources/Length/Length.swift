import Foundation

public struct Length: Equatable {

  var unit: Unit

  init(_ unit: Unit) {
    self.unit = unit
  }

  enum Unit: Equatable {
    case centimeters(Double)
    case feet(Double)
    case inches(Double)
    case meters(Double)
  }
}

extension Length {

  public static func centimeters(_ value: Double) -> Length {
    self.init(.centimeters(value))
  }

  public static func feet(_ value: Double) -> Length {
    self.init(.feet(value))
  }

  public static func inches(_ value: Double) -> Length {
    self.init(.inches(value))
  }

  public static func meters(_ value: Double) -> Length {
    self.init(.meters(value))
  }
}

// MARK: - Conversions
extension Length {

  public var centimeters: Double {
    get {
      switch unit {
      case let .centimeters(value):
        return value
      case let .feet(feet):
        return feet / 0.032808
      case let .inches(inches):
        return inches * 2.54
      case let .meters(meters):
        return meters * 100
      }
    }
    set { self = .centimeters(newValue) }
  }

  public var feet: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters * 0.032808
      case let .feet(value):
        return value
      case let .inches(inches):
        return inches / 12
      case let .meters(meters):
        return meters * 3.2808
      }
    }
    set { self = .feet(newValue) }
  }

  public var inches: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters * 0.39370
      case let .feet(feet):
        return feet * 12
      case let .inches(value):
        return value
      case let .meters(meters):
        return meters / 0.0254
      }
    }
    set { self = .inches(newValue) }
  }

  public var meters: Double {
    get {
      switch unit {
      case let .centimeters(centimeters):
        return centimeters / 100
      case let .feet(feet):
        return feet / 3.2808
      case let .inches(inches):
        return inches * 0.0254
      case let .meters(value):
        return value
      }
    }
    set { self = .meters(newValue) }
  }

  public static var seaLevel: Self {
    .init(.feet(0))
  }
}

extension Length: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(.feet(value))
  }
}

extension Length: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(.feet(Double(value)))
  }
}
