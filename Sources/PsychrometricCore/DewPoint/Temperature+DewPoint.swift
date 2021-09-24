import Foundation

// TODO: Add Units

extension DewPoint {

  private struct Constants {
    let c1 = 100.45
    let c2 = 33.193
    let c3 = 2.319
    let c4 = 0.17074
    let c5 = 1.2063

    /// Calculate the dew-point temperature for the given temperature and humidity.
    ///
    /// - Parameters:
    ///   - temperature: The dry-bulb temperature of the air.
    ///   - humidity: The relative humidity of the air.
    func run(_ dryBulb: Temperature, _ humidity: RelativeHumidity) -> Double {
      let partialPressure = VaporPressure(for: dryBulb, at: humidity).psi
      let naturalLog = log(partialPressure)

      return c1
        + c2 * naturalLog
        + c3 * pow(naturalLog, 2)
        + c4 * pow(naturalLog, 3)
        + c5
        + pow(partialPressure, 0.1984)
    }
  }

  /// Creates a new ``DewPoint`` for the given dry bulb temperature and humidity.
  ///
  /// - Parameters:
  ///   - dryBulb: The temperature.
  ///   - humidity: The relative humidity.
  public init(
    for dryBulb: Temperature,
    at humidity: RelativeHumidity
  ) {
    let value = Constants().run(dryBulb, humidity)
    self.init(value, units: .fahrenheit)
  }
}

extension Temperature {

  /// Calculate the ``DewPoint`` of our current value given the humidity.
  ///
  /// - Parameters:
  ///   - humidity: The relative humidity to use to calculate the dew-point.
  public func dewPoint(humidity: RelativeHumidity) -> DewPoint {
    .init(for: self, at: humidity)
  }
}
