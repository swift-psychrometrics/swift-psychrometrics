import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.Water.Route {

  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return await ResultEnvelope(result: density.respond())
    case let .specificHeat(specificHeat):
      return await ResultEnvelope(result: specificHeat.respond())
    }
  }
}

extension ServerRoute.Api.Route.Water.Route.SpecificHeat {
  fileprivate func respond() async -> SharedModels.SpecificHeat {
    return await .water(temperature: self.dryBulb)
  }
}

extension ServerRoute.Api.Route.Water.Route.Density {
  fileprivate func respond() async -> DensityOf<Water> {
    await .init(for: dryBulb.rawValue)
  }
}
