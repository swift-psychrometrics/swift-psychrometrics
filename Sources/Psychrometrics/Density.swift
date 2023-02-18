import SharedModels
import Dependencies
import Foundation
import PsychrometricEnvironment

/// Represents the mass per unit of volume.
///
/// Often represented by `ρ` in ASHRAE Fundamentals (2017)
///
public struct Density<T> {

  /// The raw value of the density.
  public private(set) var rawValue: Double

  /// The units of the raw value.
  public private(set) var units: DensityUnits

  /// Create a new ``Density`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw value of the density.
  ///   - units: The unit of measure for the raw value.
  public init(_ value: Double, units: DensityUnits) {
    self.rawValue = value
    self.units = units
  }
}

/// The units of measure for a ``Density`` type.
public enum DensityUnits: String, UnitOfMeasure {

  case poundsPerCubicFoot = "lb/ft^3"
  case kilogramPerCubicMeter = "kg/m^3"

  public static func defaultFor(units: PsychrometricUnits) -> Self {
    switch units {
    case .imperial: return .poundsPerCubicFoot
    case .metric: return .kilogramPerCubicMeter
    }
  }
}

public typealias DensityOf<T> = Density<T>

// MARK: - Water
extension Density where T == Water {

  // TODO: Add [SI] units.

  /// Create a new ``Density<Water>`` for the given temperature.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  public init(for temperature: Temperature) {
    let value =
      62.56
      + 3.413
      * (pow(10, -4) * temperature.fahrenheit)
      - 6.255
      * pow((pow(10, -5) * temperature.fahrenheit), 2)
    self.init(value, units: .poundsPerCubicFoot)
  }
}

// MARK: - DryAir
extension Density where T == DryAir {

  private struct Constants {
    let universalGasConstant: Double
    let units: PsychrometricUnits

    init(units: PsychrometricUnits) {
      self.units = units
      self.universalGasConstant = PsychrometricEnvironment.universalGasConstant(for: units)
    }

    func run(dryBulb: Temperature, pressure: Pressure) -> Double {
      let T = units.isImperial ? dryBulb.rankine : dryBulb.kelvin
      let pressure = units.isImperial ? pressure.psi : pressure.pascals

      guard units.isImperial else {
        return pressure / universalGasConstant / T
      }

      /// Convert pressure in pounds per square inch to pounds per cubic foot.
      return (pressure * 144) / universalGasConstant / T
    }
  }

  /// Create a new ``Density<DryAir>`` for the given temperature and pressure.
  ///
  /// **Reference**: ASHRAE Fundamentals (2017) ch. 1
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  ///   - totalPressure: The pressure to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public init(
    for temperature: Temperature,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    @Dependency(\.psychrometricEnvironment) var environment
    
    let units = units ?? environment.units
    let value = Constants(units: units).run(dryBulb: temperature, pressure: totalPressure)
    self.init(value, units: .defaultFor(units: units))
  }

  /// Create a new ``Density<DryAir>`` for the given temperature and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature to calculate the density for.
  ///   - altitude: The altitude to calculate the density for.
  public init(
    for temperature: Temperature,
    altitude: Length = .seaLevel,
    units: PsychrometricUnits? = nil
  ) {
    self.init(for: temperature, pressure: .init(altitude: altitude), units: units)
  }
}

// MARK: - MoistAir
extension Density where T == MoistAir {

  /// Create a new ``Density<MoistAir>`` for the given specific volume and humidity ratio.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - specificVolume: The specific volume to calculate the density for.
  ///   - humidityRatio: The humidity ratio to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public init(
    volume specificVolume: SpecificVolumeOf<MoistAir>,
    ratio humidityRatio: HumidityRatio,
    units: PsychrometricUnits? = nil
  ) {
    precondition(humidityRatio.rawValue > 0)
    
    @Dependency(\.psychrometricEnvironment) var environment

    let units = units ?? environment.units

    self.init(
      (1 + humidityRatio) / specificVolume.rawValue,
      units: .defaultFor(units: units)
    )
  }

  /// Create a new ``Density<MoistAir>`` for the given dry bulb temperature, relative humidity, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the density for.
  ///   - humidity: The relative humidity to calculate the density for.
  ///   - pressure: The total pressure to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public init(
    for temperature: Temperature,
    at humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      volume: .init(
        dryBulb: temperature,
        humidity: humidity,
        pressure: totalPressure,
        units: units
      ),
      ratio: .init(dryBulb: temperature, humidity: humidity, pressure: totalPressure),
      units: units
    )
  }

  /// Create a new ``Density<MoistAir>`` for the given dry bulb temperature, relative humidity, and total pressure.
  ///
  /// **Reference**:
  ///   ASHRAE - Fundamentals (2017) ch. 1 eq. 11
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature to calculate the density for.
  ///   - humidityRatio: The humidity ratio to calculate the density for.
  ///   - pressure: The total atmospheric pressure to calculate the density for.
  ///   - units: The unit of measure to solve for, will default the the ``Core.environment`` setting if not supplied.
  public init(
    dryBulb temperature: Temperature,
    ratio humidityRatio: HumidityRatio,
    pressure totalPressure: Pressure,
    units: PsychrometricUnits? = nil
  ) {
    self.init(
      volume: .init(
        dryBulb: temperature, ratio: humidityRatio, pressure: totalPressure, units: units),
      ratio: humidityRatio,
      units: units
    )
  }
}

extension Density: NumberWithUnitOfMeasure {

  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
  public typealias Units = DensityUnits

  public static func keyPath(for units: DensityUnits) -> WritableKeyPath<Density<T>, Double> {
    \.rawValue
  }
}
