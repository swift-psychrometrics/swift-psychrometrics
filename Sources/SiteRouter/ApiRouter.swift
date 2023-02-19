import Foundation
import SharedModels
import URLRouting

public func apiRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, ServerRoute.Api.Route> {
  // MARK: - Density
  let densityRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.Density.dryAir)) {
      Path(.dryAir)
      OneOf {
        Route(.case(ServerRoute.Api.Route.Density.DryAir.altitude)) {
          Path(.altitude)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Density.DryAir.Altitude.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.Density.DryAir.totalPressure)) {
          Path(.totalPressure)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Density.DryAir.Pressure.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
    Route(.case(ServerRoute.Api.Route.Density.moistAir)) {
      Path(.moistAir)
      OneOf {
        Route(.case(ServerRoute.Api.Route.Density.MoistAir.humidityRatio)) {
          Path(.humidityRatio)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Density.MoistAir.HumidityRatio.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.Density.MoistAir.relativeHumidity)) {
          Path(.relativeHumidity)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Density.MoistAir.RelativeHumidity.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.Density.MoistAir.specificVolume)) {
          Path(.specificVolume)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Density.MoistAir.SpecificVolume.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
    Route(.case(ServerRoute.Api.Route.Density.water)) {
      Path(.water)
      Method.post
      Body(
        .json(
          Temperature.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Dew Point
  let dewPointRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.DewPoint.temperature)) {
      Path(.temperature)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.DewPoint.Temperature.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.DewPoint.vaporPressure)) {
      Path(.vaporPressure)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.DewPoint.VaporPressure.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.DewPoint.wetBulb)) {
      Path(.wetBulb)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.DewPoint.WetBulb.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Enthalpy
  let enthalpyRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.Enthalpy.dryAir)) {
      Path(.dryAir)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Enthalpy.DryAir.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    
    Route(.case(ServerRoute.Api.Route.Enthalpy.moistAir)) {
      Path(.moistAir)
      OneOf {
        Route(.case(ServerRoute.Api.Route.Enthalpy.MoistAir.altitude)) {
          Path(.altitude)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Enthalpy.MoistAir.Altitude.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.Enthalpy.MoistAir.pressure)) {
          Path(.pressure)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.Enthalpy.MoistAir.Pressure.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
  }
  // MARK: - Grains of Moisture
  let grainsOfMoistureRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.GrainsOfMoisture.altitude)) {
      Path(.altitude)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.GrainsOfMoisture.Altitude.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.GrainsOfMoisture.temperature)) {
      Path(.temperature)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.GrainsOfMoisture.Temperature.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.GrainsOfMoisture.totalPressure)) {
      Path(.totalPressure)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.GrainsOfMoisture.Pressure.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Humidity Ratio
  let humidityRatioRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.HumidityRatio.dewPoint)) {
      Path(.dewPoint)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.HumidityRatio.DewPoint.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.HumidityRatio.enthalpy)) {
      Path(.enthalpy)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.HumidityRatio.Enthalpy.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.HumidityRatio.pressure)) {
      Path(.pressure)
      OneOf {
        Route(.case(ServerRoute.Api.Route.HumidityRatio.Pressure.saturation)) {
          Path(.saturation)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.HumidityRatio.Pressure.Saturation.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.HumidityRatio.Pressure.vapor)) {
          Path(.vapor)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.HumidityRatio.Pressure.Vapor.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
    Route(.case(ServerRoute.Api.Route.HumidityRatio.specificHumidity)) {
      Path(.specificHumidity)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.HumidityRatio.SpecificHumidity.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.HumidityRatio.wetBulb)) {
      Path(.wetBulb)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.HumidityRatio.WetBulb.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Psychrometrics
  let psychrometricsRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.Psychrometrics.dewPoint)) {
      Path(.dewPoint)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Psychrometrics.DewPoint.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.Psychrometrics.relativeHumidity)) {
      Path(.relativeHumidity)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Psychrometrics.RelativeHumidity.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.Psychrometrics.wetBulb)) {
      Path(.wetBulb)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Psychrometrics.WetBulb.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    
  }
  // MARK: - Relative Humidity
  let relativeHumidityRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.RelativeHumidity.humidityRatio)) {
      Path(.humidityRatio)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.RelativeHumidity.HumidityRatio.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.RelativeHumidity.vaporPressure)) {
      Path(.vaporPressure)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.RelativeHumidity.VaporPressure.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Specific Heat
  let specificHeatRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.SpecificHeat.water)) {
      Path(.water)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.SpecificHeat.Water.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
    // MARK: - Specific Volume
  let specificVolumeRouter = OneOf {
    
    Route(.case(ServerRoute.Api.Route.SpecificVolume.dryAir)) {
      Path(.dryAir)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.SpecificVolume.DryAir.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    
    Route(.case(ServerRoute.Api.Route.SpecificVolume.moistAir)) {
      Path(.moistAir)
      OneOf {
        Route(.case(ServerRoute.Api.Route.SpecificVolume.MoistAir.altitude)) {
          Path(.altitude)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.SpecificVolume.MoistAir.Altitude.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.SpecificVolume.MoistAir.humidityRatio)) {
          Path(.humidityRatio)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.SpecificVolume.MoistAir.HumidityRatio.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.SpecificVolume.MoistAir.relativeHumidity)) {
          Path(.relativeHumidity)
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.SpecificVolume.MoistAir.RelativeHumidity.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
  }
  // MARK: - Vapor Pressure
  let vaporPressureRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.VaporPressure.humidityRatio)) {
      Path(.humidityRatio)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.VaporPressure.HumidityRatio.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  // MARK: - Wet Bulb
  let wetBulbRouter = OneOf {
    Route(.case(ServerRoute.Api.Route.WetBulb.relativeHumidity)) {
      Path(.relativeHumidity)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.WetBulb.RelativeHumidity.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  
  return OneOf {
    Route(.case(ServerRoute.Api.Route.density)) {
      Path(.density)
      densityRouter
    }
    Route(.case(ServerRoute.Api.Route.dewPoint)) {
      Path(.dewPoint)
      dewPointRouter
    }
    Route(.case(ServerRoute.Api.Route.enthalpy)) {
      Path(.enthalpy)
      enthalpyRouter
    }
    Route(.case(ServerRoute.Api.Route.grainsOfMoisture)) {
      Path(.grainsOfMoisture)
      grainsOfMoistureRouter
    }
    Route(.case(ServerRoute.Api.Route.humidityRatio)) {
      Path(.humidityRatio)
      humidityRatioRouter
    }
    Route(.case(ServerRoute.Api.Route.psychrometrics)) {
      Path(.psychrometrics)
      psychrometricsRouter
    }
    Route(.case(ServerRoute.Api.Route.relativeHumidity)) {
      Path(.relativeHumidity)
      relativeHumidityRouter
    }
    Route(.case(ServerRoute.Api.Route.specificHeat)) {
      Path(.specificHeat)
      specificHeatRouter
    }
    Route(.case(ServerRoute.Api.Route.specificVolume)) {
      Path(.specificVolume)
      specificVolumeRouter
    }
    Route(.case(ServerRoute.Api.Route.vaporPressure)) {
      Path(.vaporPressure)
      vaporPressureRouter
    }
    Route(.case(ServerRoute.Api.Route.wetBulb)) {
      Path(.wetBulb)
      wetBulbRouter
    }
  }
  .eraseToAnyParserPrinter()
  
}

// MARK: - Path Helpers

enum PathKey: String, RouteKey {
  case altitude
  case density
  case dewPoint
  case dryAir
  case enthalpy
  case grainsOfMoisture
  case humidityRatio
  case moistAir
  case pressure
  case psychrometrics
  case relativeHumidity
  case saturation
  case specificHeat
  case specificHumidity
  case specificVolume
  case temperature
  case totalPressure
  case vapor
  case vaporPressure
  case water
  case wetBulb
}

extension Path where ComponentParsers == PathBuilder.Component<String> {
  init(_ key: PathKey) {
    self.init {
      key.description
    }
  }
}
