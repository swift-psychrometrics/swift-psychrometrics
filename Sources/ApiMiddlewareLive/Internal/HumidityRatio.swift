import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.HumidityRatio {
  func respond() async throws -> SharedModels.HumidityRatio {
    switch self {
    case let .dewPoint(dewPoint):
      return await .init(
        dewPoint: dewPoint.dewPoint,
        pressure: dewPoint.totalPressure.rawValue,
        units: dewPoint.units
      )
    case let .enthalpy(enthalpy):
      return await .init(
        enthalpy: enthalpy.enthalpy,
        dryBulb: enthalpy.dryBulb.rawValue
      )
    case let .pressure(pressure):
      switch pressure {
      case let .saturation(saturation):
        return await .init(
          totalPressure: saturation.totalPressure.rawValue,
          saturationPressure: saturation.saturationPressure
        )
      case let .vapor(vapor):
        return await .init(
          totalPressure: vapor.totalPressure.rawValue,
          vaporPressure: vapor.vaporPressure
        )
      }
    case let .specificHumidity(specificHumidity):
      return .init(specificHumidity: specificHumidity.specificHumidity)
    case let .wetBulb(wetBulb):
      return await .init(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}
