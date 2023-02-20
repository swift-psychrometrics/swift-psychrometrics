import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.Psychrometrics {
  
  struct PsychrometricError: Error { }

  func respond() async throws -> PsychrometricResponse {
    switch self {
    case let .dewPoint(dewPoint):
      guard let value = await PsychrometricResponse(
        dryBulb: dewPoint.dryBulb.rawValue,
        dewPoint: dewPoint.dewPoint,
        pressure: dewPoint.totalPressure.rawValue,
        units: dewPoint.units
      )
      else {
        throw PsychrometricError()
      }
      return value
    case let .relativeHumidity(relativeHumidity):
      guard let value = await PsychrometricResponse(
        dryBulb: relativeHumidity.dryBulb.rawValue,
        humidity: relativeHumidity.humidity,
        pressure: relativeHumidity.totalPressure.rawValue,
        units: relativeHumidity.units
      )
      else {
        throw PsychrometricError()
      }
      return value
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
