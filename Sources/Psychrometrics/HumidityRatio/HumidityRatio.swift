import Foundation

/// Represents the humidity ratio (or mixing ratio) of a given moist air sample.
///
/// Defined as the ratio of the mass of water vapor to the mass of dry air in the sample and is often represented
/// by the symbol `W` in the ASHRAE Fundamentals (2017).
///
/// This value can not be negative, so it will be set to ``PsychrometricEnvironment.minimumHumidityRatio`` if
/// initialized with a value that's out of range.  For methods that use a humidity ratio they should check that the humidity ratio
/// is valid by calling ``HumidityRatio.ensureHumidityRatio(_:)``.
///
public struct HumidityRatio: Equatable {

  /// Constant for the mole weight of water.
  public static let moleWeightWater = 18.015268

  /// Constant for the mole weight of air.
  public static let moleWeightAir = 28.966

  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static let moleWeightRatio = (Self.moleWeightWater / Self.moleWeightAir)

  public static func ensureHumidityRatio(_ ratio: HumidityRatio) -> HumidityRatio {
    guard ratio.rawValue > PsychrometricEnvironment.shared.minimumHumidityRatio else {
      return .init(PsychrometricEnvironment.shared.minimumHumidityRatio)
    }
    return ratio
  }

  /// The raw humidity ratio.
  public var rawValue: Double

  /// Create a new ``HumidityRatio`` with the given raw value.
  ///
  /// - Parameters:
  ///   - value: The raw humidity ratio value.
  public init(_ value: Double) {
    self.rawValue = max(value, PsychrometricEnvironment.shared.minimumHumidityRatio)
  }

  /// The humidity ratio of air for the given mass of water and mass of dry air.
  ///
  /// - Parameters:
  ///   - waterMass: The mass of the water in the air.
  ///   - dryAirMass: The mass of the dry air.
  public init(
    water waterMass: Double,
    dryAir dryAirMass: Double
  ) {
    self.init(Self.moleWeightRatio * (waterMass / dryAirMass))
  }

  internal init(
    totalPressure: Pressure,
    partialPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    let units = units ?? PsychrometricEnvironment.shared.units
    let partialPressure =
      units.isImperial ? partialPressure.psi : partialPressure.pascals
    let totalPressure = units.isImperial ? totalPressure.psi : totalPressure.pascals

    self.init(
      Self.moleWeightRatio * partialPressure
        / (totalPressure - partialPressure)
    )
  }

  /// The  humidity ratio of the air for the given total pressure and vapor pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - vaporPressure: The partial pressure of the air.
  public init(
    totalPressure: Pressure,
    vaporPressure: VaporPressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: vaporPressure.pressure,
      units: units
    )
  }

  /// The  humidity ratio of the air for the given total pressure and saturation pressure.
  ///
  /// - Parameters:
  ///   - totalPressure: The total pressure of the air.
  ///   - saturationPressure: The saturation of the air.
  public init(
    totalPressure: Pressure,
    saturationPressure: SaturationPressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: saturationPressure.pressure,
      units: units
    )
  }

  /// The  humidity ratio of the air for the given dry bulb temperature and total pressure.
  ///
  /// - Parameters:
  ///   - temperature: The dry bulb temperature of the air.
  ///   - totalPressure: The total pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      saturationPressure: .init(at: temperature, units: units),
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and pressure.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - totalPressure: The pressure of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    pressure totalPressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      totalPressure: totalPressure,
      partialPressure: VaporPressure(
        dryBulb: temperature,
        humidity: humidity,
        units: units
      ).pressure,
      units: units
    )
  }

  /// The humidity ratio of the air for the given temperature, humidity, and altitude.
  ///
  /// - Parameters:
  ///   - temperature: The temperature of the air.
  ///   - humidity: The humidity of the air.
  ///   - altitude: The altitude of the air.
  public init(
    dryBulb temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    self.init(
      dryBulb: temperature,
      humidity: humidity,
      pressure: .init(altitude: altitude),
      units: units
    )
  }
}

extension HumidityRatio: RawNumericType {
  public typealias IntegerLiteralType = Double.IntegerLiteralType
  public typealias FloatLiteralType = Double.FloatLiteralType
  public typealias Magnitude = Double.Magnitude
}
