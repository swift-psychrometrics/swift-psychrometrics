import SharedModels

extension ServerRoute.Api.Route.DryAir.Route {
  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return try await density.response()
    case let .enthalpy(enthalpy):
      return try await enthalpy.respond()
    case let .specificVolume(specificVolume):
      return await specificVolume.response()
    }
  }
}

fileprivate extension ServerRoute.Api.Route.DryAir.Route.SpecificVolume {
  func response() async -> SpecificVolume<SharedModels.DryAir> {
    await .init(dryBulb: self.dryBulb.rawValue, pressure: self.totalPressure.rawValue, units: self.units)
  }
}

fileprivate extension ServerRoute.Api.Route.DryAir.Route.Density.Route {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    switch self {
    case let .altitude(altitude):
      return try await altitude.response()
    case let .totalPressure(totalPressure):
      return try await totalPressure.response()
    }
  }
}

fileprivate extension ServerRoute.Api.Route.DryAir.Route.Density.Route.Altitude {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    return await .init(for: self.dryBulb.rawValue, altitude: self.altitude, units: self.units)
  }
}

fileprivate extension ServerRoute.Api.Route.DryAir.Route.Density.Route.Pressure {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    await .init(
      for: self.dryBulb.rawValue,
      pressure: self.totalPressure.rawValue,
      units: self.units
    )
  }
}

fileprivate extension ServerRoute.Api.Route.DryAir.Route.Enthalpy {
  func respond() async throws -> DryAirEnthalpy {
    return await .init(dryBulb: self.dryBulb.rawValue, units: self.units)
  }
}
