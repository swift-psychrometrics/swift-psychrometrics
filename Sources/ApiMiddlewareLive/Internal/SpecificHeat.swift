import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.SpecificHeat {
  func respond() async throws -> SharedModels.SpecificHeat {
    switch self {
    case let .water(water):
      return await .water(temperature: water.dryBulb)
    }
  }
}
