import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.MoistAir.Route {
  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return try await ResultEnvelope(result: density.response())
    case let .dewPoint(dewPoint):
      return try await ResultEnvelope(result: dewPoint.respond())
    case let .enthalpy(enthalpy):
      return try await ResultEnvelope(result: enthalpy.respond())
    case let .grainsOfMoisture(grainsOfMoisture):
      return try await ResultEnvelope(result: grainsOfMoisture.respond())
    case let .humidityRatio(humidityRatio):
      return try await ResultEnvelope(result: humidityRatio.respond())
    case let .psychrometrics(psychrometrics):
      return try await ResultEnvelope(result: psychrometrics.respond())
    case let .relativeHumidity(relativeHumidity):
      return try await ResultEnvelope(result: relativeHumidity.respond())
    case let .specificVolume(specificVolume):
      return try await ResultEnvelope(result: specificVolume.respond())
    case let .vaporPressure(vaporPressure):
      return try await ResultEnvelope(result: vaporPressure.respond())
    case let .wetBulb(wetBulb):
      return try await ResultEnvelope(result: wetBulb.respond())
    }
  }
}

// MARK: - Density

extension ServerRoute.Api.Route.MoistAir.Route.Density.Route {

  fileprivate func respond() async throws -> any Encodable {
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

extension ServerRoute.Api.Route.MoistAir.Route.Density.Route {
  fileprivate func response() async throws -> DensityOf<SharedModels.MoistAir> {
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

extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.HumidityRatio {
  fileprivate func response() async throws -> DensityOf<SharedModels.MoistAir> {
    try await .init(
      dryBulb: dryBulb.rawValue,
      ratio: humidityRatio,
      pressure: totalPressure.rawValue
    )
  }
}

extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.RelativeHumidity {
  fileprivate func response() async throws -> DensityOf<SharedModels.MoistAir> {
    try await .init(
      for: dryBulb.rawValue,
      at: humidity,
      pressure: totalPressure.rawValue
    )
  }
}

extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.SpecificVolume {
  fileprivate func response() async throws -> DensityOf<SharedModels.MoistAir> {
    try await .init(
      volume: specificVolume,
      ratio: humidityRatio
    )
  }
}

// MARK: - Dew Point
extension ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route {

  fileprivate func respond() async throws -> DewPoint {
    switch self {
    case let .temperature(temperature):
      return try await DewPoint(
        dryBulb: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .vaporPressure(vaporPressure):
      return await DewPoint(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure
      )
    case let .wetBulb(wetBulb):
      return try await DewPoint(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}

// MARK: - Enthalpy
extension ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route {

  fileprivate func respond() async throws -> MoistAirEnthalpy {
    switch self {
    case let .altitude(altitude):
      return try await MoistAirEnthalpy(
        dryBulb: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude,
        units: altitude.units
      )
    case let .totalPressure(pressure):
      return try await MoistAirEnthalpy(
        dryBulb: pressure.dryBulb.rawValue,
        humidity: pressure.humidity,
        pressure: pressure.totalPressure.rawValue,
        units: pressure.units
      )
    }
  }
}

// MARK: - Grains of Moisture
extension ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route {
  fileprivate func respond() async throws -> GrainsOfMoisture {
    switch self {
    case let .altitude(altitude):
      return try await .init(
        temperature: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude
      )
    case let .temperature(temperature):
      return try await .init(
        temperature: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .totalPressure(totalPressure):
      return try await .init(
        temperature: totalPressure.dryBulb.rawValue,
        humidity: totalPressure.humidity,
        pressure: totalPressure.totalPressure.rawValue
      )
    }
  }
}

// MARK: Humidity Ratio
extension ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route {
  fileprivate func respond() async throws -> SharedModels.HumidityRatio {
    switch self {
    case let .dewPoint(dewPoint):
      return try await .init(
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
      return try .init(specificHumidity: specificHumidity.specificHumidity)
    case let .wetBulb(wetBulb):
      return try await .init(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}

// MARK: - Psychrometrics
extension ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route {

  fileprivate struct PsychrometricError: Error {}

  fileprivate func respond() async throws -> PsychrometricResponse {
    switch self {
    case let .altitude(altitude):
      guard
        let value = try await PsychrometricResponse(
          altitude: altitude.altitude,
          dryBulb: altitude.dryBulb.rawValue,
          humidity: altitude.humidity,
          units: altitude.units
        )
      else {
        throw PsychrometricError()
      }
      return value
    case let .dewPoint(dewPoint):
      guard
        let value = try await PsychrometricResponse(
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
      guard
        let value = try await PsychrometricResponse(
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
      return try await .init(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}

// MARK: - Relative Humidity
extension ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route {

  fileprivate func respond() async throws -> SharedModels.RelativeHumidity {
    switch self {
    case let .humidityRatio(humidityRatio):
      return try await .init(
        dryBulb: humidityRatio.dryBulb.rawValue,
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    case let .vaporPressure(vaporPressure):
      return try await .init(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure,
        units: vaporPressure.units
      )
    }
  }
}

// MARK: - Specific Volume
extension ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route {
  fileprivate func respond() async throws -> SpecificVolume<SharedModels.MoistAir> {
    switch self {
    case let .altitude(altitude):
      return try await SpecificVolume<SharedModels.MoistAir>.init(
        dryBulb: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude,
        units: altitude.units
      )
    case let .humidityRatio(humidityRatio):
      return try await SpecificVolume<SharedModels.MoistAir>.init(
        dryBulb: humidityRatio.dryBulb.rawValue,
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    case let .relativeHumidity(relativeHumidity):
      return try await SpecificVolume<SharedModels.MoistAir>.init(
        dryBulb: relativeHumidity.dryBulb.rawValue,
        humidity: relativeHumidity.humidity,
        pressure: relativeHumidity.totalPressure.rawValue,
        units: relativeHumidity.units
      )
    }
  }
}

// MARK: - Vapor Pressure
extension ServerRoute.Api.Route.MoistAir.Route.VaporPressure.Route {
  fileprivate func respond() async throws -> SharedModels.VaporPressure {
    switch self {
    case let .humidityRatio(humidityRatio):
      return try .init(
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    }
  }
}

// MARK: - Wet Bulb
extension ServerRoute.Api.Route.MoistAir.Route.WetBulb.Route {

  fileprivate struct WetBulbError: Error {}
  fileprivate func respond() async throws -> SharedModels.WetBulb {
    switch self {
    case let .relativeHumidity(relativeHumidity):
      guard
        let value = try await SharedModels.WetBulb(
          dryBulb: relativeHumidity.dryBulb.rawValue,
          humidity: relativeHumidity.humidity,
          pressure: relativeHumidity.totalPressure.rawValue,
          units: relativeHumidity.units
        )
      else {
        throw WetBulbError()
      }
      return value
    }
  }
}
