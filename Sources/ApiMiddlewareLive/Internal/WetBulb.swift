import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.WetBulb {
  
  struct WetBulbError: Error { }
  func respond() async throws -> SharedModels.WetBulb {
    switch self {
    case let .relativeHumidity(relativeHumidity):
      guard let value = await SharedModels.WetBulb(
        dryBulb: relativeHumidity.dryBulb.rawValue,
        humidity: relativeHumidity.humidity,
        pressure: relativeHumidity.totalPressure.rawValue,
        units: relativeHumidity.units
      )
      else {
        throw WetBulbError()
      }
      return value
    }
  }
}
