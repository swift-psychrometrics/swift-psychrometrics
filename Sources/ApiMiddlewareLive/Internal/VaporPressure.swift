import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.VaporPressure {
  func respond() async throws -> SharedModels.VaporPressure {
    switch self {
    case let .humidityRatio(humidityRatio):
      return .init(
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    }
  }
}
