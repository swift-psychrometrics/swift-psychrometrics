import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.Water.Route {
  
  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return await density.respond()
    case let .specificHeat(specificHeat):
      return await specificHeat.respond()
    }
  }
}

fileprivate extension ServerRoute.Api.Route.Water.Route.SpecificHeat {
  func respond() async -> SharedModels.SpecificHeat {
    return await .water(temperature: self.dryBulb)
  }
}

fileprivate extension ServerRoute.Api.Route.Water.Route.Density {
  func respond() async -> DensityOf<Water> {
    await .init(for: dryBulb.rawValue)
  }
}
