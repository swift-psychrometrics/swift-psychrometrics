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
  case let .dryAir(dryAir):
    return try await dryAir.respond()
  case let .moistAir(moistAir):
    return try await moistAir.respond()
  case let .water(water):
    return try await water.respond()
  }
}
