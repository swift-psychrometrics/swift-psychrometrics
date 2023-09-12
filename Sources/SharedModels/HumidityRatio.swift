import Tagged

/// Represents the humidity ratio (or mixing ratio) of a given moist air sample.
///
/// Defined as the ratio of the mass of water vapor to the mass of dry air in the sample and is often represented
/// by the symbol `W` in the ASHRAE Fundamentals (2017).
///
/// This value can not be negative, so it will be set to ``PsychrometricEnvironment/minimumHumidityRatio`` if
/// initialized with a value that's out of range.  For methods that use a humidity ratio they should check that the humidity ratio
/// is valid by calling ``HumidityRatio/ensureHumidityRatio(_:)``.
///
public typealias HumidityRatio = Tagged<Ratio, Humidity<Ratio>>

//public struct HumidityRatio: Codable, Equatable, Sendable {
extension HumidityRatio {

  /// Constant for the mole weight of water.
  public static var moleWeightWater: Double {
    18.015268
  }

  /// Constant for the mole weight of air.
  public static var moleWeightAir: Double {
    28.966
  }

  /// Constant for the ratio of the mole weight of water over the mole weight of air.
  public static var moleWeightRatio: Double {
    (Self.moleWeightWater / Self.moleWeightAir)
  }

}
