@_exported import ApiMiddleware
import Dependencies
import Psychrometrics
import SharedModels

extension ApiMiddleware: DependencyKey {
  public static var liveValue: ApiMiddleware {
    .init(
      apiResponse: ApiMiddlewareLive.apiRespond(route:),
      respond: ApiMiddlewareLive.respond(api:)
    )
  }
}

fileprivate func respond(api: ServerRoute.Api) async throws -> any Encodable {
  return try await apiRespond(route: api.route)
}

fileprivate func apiRespond(route: ServerRoute.Api.Route) async throws -> any Encodable {
  switch route {
  case let .density(density):
    return try await density.respond()
  case let .dewPoint(dewPoint):
    return try await dewPoint.respond()
  case let .enthalpy(enthalpy):
    return try await enthalpy.respond()
  case let .grainsOfMoisture(grainsOfMoisture):
    return try await grainsOfMoisture.respond()
  case let .humidityRatio(humidityRatio):
    return try await humidityRatio.respond()
  case let .psychrometrics(psychrometrics):
    return try await psychrometrics.respond()
  case let .relativeHumidity(relativeHumidity):
    return try await relativeHumidity.respond()
  case let .specificHeat(specificHeat):
    return try await specificHeat.respond()
  case let .specificVolume(specificVolume):
    return try await specificVolume.respond()
  case let .vaporPressure(vaporPressure):
    return try await vaporPressure.respond()
  case let .wetBulb(wetBulb):
    return try await wetBulb.respond()
  }
}
