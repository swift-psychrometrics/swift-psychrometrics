import Psychrometrics
import SharedModels

extension ServerRoute.Api.Route.MoistAir.Route {
  func respond() async throws -> any Encodable {
    switch self {
    case let .density(density):
      return try await density.response()
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
    case let .specificVolume(specificVolume):
      return try await specificVolume.respond()
    case let .vaporPressure(vaporPressure):
      return try await vaporPressure.respond()
    case let .wetBulb(wetBulb):
      return try await wetBulb.respond()
    }
  }
}

// MARK: - Density

fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Density.Route {

  func respond() async throws -> any Encodable {
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

fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Density.Route {
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

fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.HumidityRatio {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      dryBulb: dryBulb.rawValue,
      ratio: humidityRatio,
      pressure: totalPressure.rawValue
    )
  }
}

fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.RelativeHumidity {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      for: dryBulb.rawValue,
      at: humidity,
      pressure: totalPressure.rawValue
    )
  }
}

fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Density.Route.SpecificVolume {
  func response() async throws -> DensityOf<SharedModels.MoistAir> {
    await .init(
      volume: specificVolume,
      ratio: humidityRatio
    )
  }
}

// MARK: - Dew Point
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route {
  
  func respond() async throws -> DewPoint {
    switch self {
    case let .temperature(temperature):
      return await DewPoint(
        dryBulb: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .vaporPressure(vaporPressure):
      return await DewPoint(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure
      )
    case let .wetBulb(wetBulb):
      return await DewPoint(
        dryBulb: wetBulb.dryBulb.rawValue,
        wetBulb: wetBulb.wetBulb,
        pressure: wetBulb.totalPressure.rawValue,
        units: wetBulb.units
      )
    }
  }
}

// MARK: - Enthalpy
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route {
  
  func respond() async throws -> any Encodable {
    switch self {
    case let .altitude(altitude):
      return await MoistAirEnthalpy(
        dryBulb: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude,
        units: altitude.units
      )
    case let .totalPressure(pressure):
      return await MoistAirEnthalpy(
        dryBulb: pressure.dryBulb.rawValue,
        humidity: pressure.humidity,
        pressure: pressure.totalPressure.rawValue,
        units: pressure.units
      )
    }
  }
}

// MARK: - Grains of Moisture
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route {
  func respond() async throws -> GrainsOfMoisture {
    switch self {
    case let .altitude(altitude):
      return await .init(
        temperature: altitude.dryBulb.rawValue,
        humidity: altitude.humidity,
        altitude: altitude.altitude
      )
    case let .temperature(temperature):
      return await .init(
        temperature: temperature.dryBulb.rawValue,
        humidity: temperature.humidity
      )
    case let .totalPressure(totalPressure):
      return await .init(
        temperature: totalPressure.dryBulb.rawValue,
        humidity: totalPressure.humidity,
        pressure: totalPressure.totalPressure.rawValue
      )
    }
  }
}

// MARK: Humidity Ratio
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route {
  func respond() async throws -> SharedModels.HumidityRatio {
    switch self {
    case let .dewPoint(dewPoint):
      return await .init(
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
      return .init(specificHumidity: specificHumidity.specificHumidity)
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

// MARK: - Psychrometrics
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route {
  
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

// MARK: - Relative Humidity
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route {
  
  func respond() async throws -> SharedModels.RelativeHumidity {
    switch self {
    case let .humidityRatio(humidityRatio):
      return await .init(
        dryBulb: humidityRatio.dryBulb.rawValue,
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    case let .vaporPressure(vaporPressure):
      return await .init(
        dryBulb: vaporPressure.dryBulb.rawValue,
        vaporPressure: vaporPressure.vaporPressure,
        units: vaporPressure.units
      )
    }
  }
}

// MARK: - Specific Volume
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route {
  func respond() async throws -> any Encodable {
    switch self {
      case let .altitude(altitude):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: altitude.dryBulb.rawValue,
          humidity: altitude.humidity,
          altitude: altitude.altitude,
          units: altitude.units
        )
      case let .humidityRatio(humidityRatio):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: humidityRatio.dryBulb.rawValue,
          ratio: humidityRatio.humidityRatio,
          pressure: humidityRatio.totalPressure.rawValue,
          units: humidityRatio.units
        )
      case let .relativeHumidity(relativeHumidity):
        return await SpecificVolume<SharedModels.MoistAir>.init(
          dryBulb: relativeHumidity.dryBulb.rawValue,
          humidity: relativeHumidity.humidity,
          pressure: relativeHumidity.totalPressure.rawValue,
          units: relativeHumidity.units
        )
    }
  }
}

// MARK: - Vapor Pressure
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.VaporPressure.Route {
  func respond() async throws -> SharedModels.VaporPressure {
    switch self {
    case let .humidityRatio(humidityRatio):
      return .init(
        ratio: humidityRatio.humidityRatio,
        pressure: humidityRatio.totalPressure.rawValue,
        units: humidityRatio.units
      )
    }
  }
}

// MARK: - Wet Bulb
fileprivate extension ServerRoute.Api.Route.MoistAir.Route.WetBulb.Route {
  
  struct WetBulbError: Error { }
  func respond() async throws -> SharedModels.WetBulb {
    switch self {
    case let .relativeHumidity(relativeHumidity):
      guard let value = await SharedModels.WetBulb(
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
