import Foundation
import Pressure
import RelativeHumidity

extension Pressure {

  public static func partialPressure(for temperature: Temperature, at humidity: RelativeHumidity)
    -> Pressure
  {
    .psi(humidity.fraction * Pressure.saturationPressure(at: temperature).psi)
  }
}
