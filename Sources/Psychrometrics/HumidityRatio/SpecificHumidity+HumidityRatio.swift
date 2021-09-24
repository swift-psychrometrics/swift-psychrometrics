import Foundation

extension HumidityRatio {

  /// Create a new ``HumidityRatio`` from the given specific humidity.
  ///
  /// **Reference**:  ASHRAE Handbook - Fundamentals (2017) ch. 1 eqn 9b (solved for humidity ratio)
  ///
  /// - Parameters:
  ///   - specificHumidity: The specific humidity.
  public init(specificHumidity: SpecificHumidity) {
    precondition(
      specificHumidity.rawValue > 0.0 && specificHumidity.rawValue < 1.0
    )
    self.init(specificHumidity.rawValue / (1 - specificHumidity.rawValue))
  }
}
