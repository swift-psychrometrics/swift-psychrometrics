import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.Density {

  func respond() async throws -> any Encodable {
    switch self {
    case let .dryAir(dryAir):
      return try await dryAir.response()
    case let .moistAir(moistAir):
      return try await moistAir.response()
    case let .water(water):
      return try await water.response()
    }
  }
}

// MARK: - Dry Air
extension ServerRoute.Api.Route.Density.DryAir {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    switch self {
    case let .altitude(altitude):
      return try await altitude.response()
    case let .totalPressure(totalPressure):
      return try await totalPressure.response()
    }
  }
}
extension ServerRoute.Api.Route.Density.DryAir.Altitude {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    return await .init(for: self.dryBulb.rawValue, altitude: self.altitude, units: self.units)
  }
}

extension ServerRoute.Api.Route.Density.DryAir.Pressure {
  func response() async throws -> DensityOf<SharedModels.DryAir> {
    await .init(
      for: self.dryBulb.rawValue,
      pressure: self.totalPressure.rawValue,
      units: self.units
    )
  }
}

// MARK: - Moist Air
extension ServerRoute.Api.Route.Density.MoistAir {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    switch self {
    case let .humidityRatio(humidityRatio):
      return try await humidityRatio.response()
    case let .relativeHumidity(relativeHumidity):
      return try await relativeHumidity.response()
    case let .specificVolume(specificVolume):
      return try await specificVolume.response()
    }
  }
}

extension ServerRoute.Api.Route.Density.MoistAir.HumidityRatio {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      dryBulb: dryBulb.rawValue,
      ratio: humidityRatio,
      pressure: totalPressure.rawValue
    )
  }
}

extension ServerRoute.Api.Route.Density.MoistAir.RelativeHumidity {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      for: dryBulb.rawValue,
      at: humidity,
      pressure: totalPressure.rawValue
    )
  }
}

extension ServerRoute.Api.Route.Density.MoistAir.SpecificVolume {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      volume: specificVolume,
      ratio: humidityRatio
    )
  }
}

// MARK: Water
fileprivate extension ServerRoute.Api.Route.Density.Water {
  func response() async throws -> DensityOf<Water> {
    await .init(for: dryBulb.rawValue)
  }
}
