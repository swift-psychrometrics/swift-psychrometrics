import Foundation
import Length
import Pressure
import RelativeHumidity
import Temperature

// TODO: Add units of measure.
public struct GrainsOfMoisture: Equatable {

  public var altitude: Length
  public var temperature: Temperature
  public var humidity: RelativeHumidity

  public let moleWeightWater = 18.02
  public let moleWeightAir = 28.85

  public var vaporPressure: Pressure {
    .vaporPressure(at: temperature)
  }

  public var ambientPressure: Pressure {
    .init(altitude: altitude)
  }

  public var saturationHumidity: Double {
    7000 * (moleWeightWater / moleWeightAir) * vaporPressure.psi
      / (ambientPressure.psi - vaporPressure.psi)
  }

  // Grains per pound
  public var rawValue: Double {
    saturationHumidity * humidity.fraction
  }

  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.temperature = temperature
    self.humidity = humidity
    self.altitude = altitude
  }

}

extension Temperature {

  public func grains(humidity: RelativeHumidity, altitude: Length = .seaLevel) -> GrainsOfMoisture {
    .init(temperature: self, humidity: humidity, altitude: altitude)
  }
}
