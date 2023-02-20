import SharedModels
import Psychrometrics

extension ServerRoute.Api.Route.DewPoint {
  
  func respond() async throws -> DewPoint {
    switch self {
    case let .temperature(temperature):
      return DewPoint(
        dryBulb: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .vaporPressure(vaporPressure):
      return DewPoint(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure
      )
    case let .wetBulb(wetBulb):
      return DewPoint(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}
