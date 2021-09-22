import Core
import Foundation

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

  /// Creates a new ``DewPoint`` for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The temperature.
  ///   - humidity: The relative humidity.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity
  ) {
    self.init(Self.calculate(for: temperature, at: humidity))
  }
  
//  public init(
//    for temperature: Temperature,
//    partialPressure: Pressure
//  ) {
//    let units = environment.units
//    
//    let lowSaturationPressure: Pressure = units == .imperial
//      ? .saturationPressure(at: .fahrenheit(-148))
//      : .saturationPressure(at: .celsius(-100))
//    
//    let highSaturationPressure: Pressure = units == .imperial
//      ? .saturationPressure(at: .fahrenheit(392))
//      : .saturationPressure(at: .celsius(200))
//    
//    precondition(
//      units == .imperial
//      ? temperature.fahrenheit > -148 && temperature.fahrenheit < 392
//      : temperature.celsius > -100 && temperature.celsius < 200
//    )
//    
//    precondition(
//      partialPressure > lowSaturationPressure && partialPressure < highSaturationPressure
//    )
//    
//    // First guesses.
//    var dewPoint = temperature
//    let logNaturalOfPartialPressure = log(units == .imperial ? partialPressure.psi : partialPressure.pascals)
//    
//    var index = 1
//    
//    while true {
//      let dewPoint_iter = dewPoint
//      let ln_iter = log(units == .imperial ? dewPoint_iter.fahrenheit : dewPoint_iter.celsius)
//    }
//    
//  }

  /// Access values on the wrapped temperature.
  public subscript<V>(dynamicMember keyPath: KeyPath<Temperature, V>) -> V {
    rawValue[keyPath: keyPath]
  }
}

extension DewPoint {
  /// Calculate the dew-point temperature for the given temperature and humidity.
  ///
  /// - Parameters:
  ///   - temperature: The dry-bulb temperature of the air.
  ///   - humidity: The relative humidity of the air.
  private static func calculate(
    for temperature: Temperature,
    at humidity: RelativeHumidity
  ) -> Temperature {
    let partialPressure = Pressure.partialPressure(for: temperature, at: humidity).psi
    let naturalLog = log(partialPressure)
    let c1 = 100.45
    let c2 = 33.193
    let c3 = 2.319
    let c4 = 0.17074
    let c5 = 1.2063

    let value =
      c1
      + c2 * naturalLog
      + c3 * pow(naturalLog, 2)
      + c4 * pow(naturalLog, 3)
      + c5
      + pow(partialPressure, 0.1984)

    return .fahrenheit(value)
  }
  
  private static func derivativeOfSaturationPressureBelowFreezing(
    _ temperature: Temperature,
    _ units: PsychrometricEnvironment.Units
  ) -> Pressure {
    let T = units == .imperial ? temperature.rankine : temperature.kelvin
    let constants = Pressure.SaturationConstantsBelowFreezing(units: units)
    
    let value = (constants.c1 * -1)
      / pow(T, 2)
      + constants.c3
      + 2 * constants.c4 * T
      + 3 * constants.c5 * pow(T, 2)
      - 4 * (constants.c6 * -1) * pow(T, 3)
      + constants.c7 / T
    
    return units == .imperial ? .psi(value) : .pascals(value)
  }
  
  private static func derivativeOfSaturationPressureAboveFreezing(
    _ temperature: Temperature,
    _ units: PsychrometricEnvironment.Units
  ) -> Pressure {
    let T = units == .imperial ? temperature.rankine : temperature.kelvin
    let constants = Pressure.SaturationConstantsAboveFreezing(units: units)
    
    let value = (constants.c1 * -1)
      / pow(T, 2)
      + constants.c3
      + 2 * constants.c4 * T
      - 3 * (constants.c5 * -1) * pow(T, 2)
      + (constants.c6)
      / T
    
    return units == .imperial ? .psi(value) : .pascals(value)
  }
  
  private static func derivativeOfSaturationPressure(_ temperature: Temperature) -> Pressure {
    let units = environment.units
    let T = units == .imperial ? temperature.rankine : temperature.kelvin
    let triplePoint = environment.triplePointOfWater
    
    return T <= triplePoint.rawValue
      ? derivativeOfSaturationPressureBelowFreezing(temperature, units)
      : derivativeOfSaturationPressureAboveFreezing(temperature, units)
  }
}


extension DewPoint: RawNumericType {
  public typealias IntegerLiteralType = Temperature.IntegerLiteralType
  public typealias FloatLiteralType = Temperature.FloatLiteralType
  public typealias Magnitude = Temperature.Magnitude
}
