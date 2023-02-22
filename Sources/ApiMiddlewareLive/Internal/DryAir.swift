import SharedModels

extension ServerRoute.Api.Route.DryAir.Route {
  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return try await ResultEnvelope(result: density.response())
    case let .enthalpy(enthalpy):
      return try await ResultEnvelope(result: enthalpy.respond())
    case let .specificVolume(specificVolume):
      return await ResultEnvelope(result: specificVolume.response())
    }
  }
}

extension ServerRoute.Api.Route.DryAir.Route.SpecificVolume {
  fileprivate func response() async -> SpecificVolume<SharedModels.DryAir> {
    await .init(
      dryBulb: self.dryBulb.rawValue, pressure: self.totalPressure.rawValue, units: self.units)
  }
}

extension ServerRoute.Api.Route.DryAir.Route.Density.Route {
  fileprivate func response() async throws -> DensityOf<SharedModels.DryAir> {
    switch self {
    case let .altitude(altitude):
      return try await altitude.response()
    case let .totalPressure(totalPressure):
      return try await totalPressure.response()
    }
  }
}

extension ServerRoute.Api.Route.DryAir.Route.Density.Route.Altitude {
  fileprivate func response() async throws -> DensityOf<SharedModels.DryAir> {
    return await .init(for: self.dryBulb.rawValue, altitude: self.altitude, units: self.units)
  }
}

extension ServerRoute.Api.Route.DryAir.Route.Density.Route.Pressure {
  fileprivate func response() async throws -> DensityOf<SharedModels.DryAir> {
    await .init(
      for: self.dryBulb.rawValue,
      pressure: self.totalPressure.rawValue,
      units: self.units
    )
  }
}

extension ServerRoute.Api.Route.DryAir.Route.Enthalpy {
  fileprivate func respond() async throws -> DryAirEnthalpy {
    return await .init(dryBulb: self.dryBulb.rawValue, units: self.units)
  }
}
