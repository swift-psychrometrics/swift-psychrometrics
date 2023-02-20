import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.GrainsOfMoisture {
  func respond() async throws -> GrainsOfMoisture {
    switch self {
    case let .altitude(altitude):
      return .init(
        temperature: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude
      )
    case let .temperature(temperature):
      return .init(
        temperature: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .totalPressure(totalPressure):
      return .init(
        temperature: totalPressure.dryBulb.rawValue,
        humidity: totalPressure.humidity,
        pressure: totalPressure.totalPressure.rawValue
      )
    }
  }
}
