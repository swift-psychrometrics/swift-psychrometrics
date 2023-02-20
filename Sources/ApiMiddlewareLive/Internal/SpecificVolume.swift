import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.SpecificVolume {
  func respond() async throws -> any Encodable {
    switch self {
    case let .dryAir(dryAir):
      return await SpecificVolume<SharedModels.DryAir>.init(
        dryBulb: dryAir.dryBulb.rawValue,
        pressure: dryAir.totalPressure.rawValue,
        units: dryAir.units
      )
    case let .moistAir(moistAir):
      switch moistAir {
      case let .altitude(altitude):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: altitude.dryBulb.rawValue,
          humidity: altitude.humidity,
          altitude: altitude.altitude,
          units: altitude.units
        )
      case let .humidityRatio(humidityRatio):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: humidityRatio.dryBulb.rawValue,
          ratio: humidityRatio.humidityRatio,
          pressure: humidityRatio.totalPressure.rawValue,
          units: humidityRatio.units
        )
      case let .relativeHumidity(relativeHumidity):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: relativeHumidity.dryBulb.rawValue,
          humidity: relativeHumidity.humidity,
          pressure: relativeHumidity.totalPressure.rawValue,
          units: relativeHumidity.units
        )
      }
    }
  }
}
