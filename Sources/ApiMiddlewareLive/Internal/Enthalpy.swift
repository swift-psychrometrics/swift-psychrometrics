import SharedModels
import Psychrometrics

extension ServerRoute.Api.Route.Enthalpy {
  
  func respond() async throws -> any Encodable {
    switch self {
    case let .dryAir(dryAir):
      return dryAir.dryBulb.rawValue
        .enthalpy(units: dryAir.units)
    case let .moistAir(moistAir):
      switch moistAir {
      case let .altitude(altitude):
        return MoistAirEnthalpy(
          dryBulb: altitude.dryBulb.rawValue,
          humidity: altitude.humidity,
          altitude: altitude.altitude,
          units: altitude.units
        )
      case let .pressure(pressure):
        return MoistAirEnthalpy(
          dryBulb: pressure.dryBulb.rawValue,
          humidity: pressure.humidity,
          pressure: pressure.totalPressure.rawValue,
          units: pressure.units
        )
      }
    }
  }
}
