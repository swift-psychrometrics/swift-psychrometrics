import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.RelativeHumidity {
  
  func respond() async throws -> SharedModels.RelativeHumidity {
    switch self {
    case let .humidityRatio(humidityRatio):
      return await .init(
        dryBulb: humidityRatio.dryBulb.rawValue,
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    case let .vaporPressure(vaporPressure):
      return await .init(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure,
        units: vaporPressure.units
      )
    }
  }
}
