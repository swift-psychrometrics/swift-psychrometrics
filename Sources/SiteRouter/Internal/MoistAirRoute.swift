import Foundation
import SharedModels
import URLRouting

struct MoistAirRouter: SiteRouteRouter {
  
  let decoder: JSONDecoder
  let encoder: JSONEncoder
  
  @ParserBuilder
  var body: AnyParserPrinter<URLRequestData, Route2.MoistAir> {
    Route(.memberwise(Route2.MoistAir.init(route:))) {
      OneOf {
        Route(.case(Route2.MoistAir.Route.density)) {
          Path(.density)
          densityRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.dewPoint)) {
          Path(.dewPoint)
          dewPointRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.enthalpy)) {
          Path(.enthalpy)
          enthalpyRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.grainsOfMoisture)) {
          Path(.grainsOfMoisture)
          grainsOfMoistureRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.humidityRatio)) {
          Path(.humidityRatio)
          humidityRatioRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.psychrometrics)) {
          Path(.psychrometrics)
          psychrometricsRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.relativeHumidity)) {
          Path(.relativeHumidity)
          relativeHumidityRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.specificVolume)) {
          Path(.specificVolume)
          specificVolumeRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.vaporPressure)) {
          Path(.vaporPressure)
          vaporPressureRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.MoistAir.Route.wetBulb)) {
          Path(.wetBulb)
          wetBulbRouter(decoder: decoder, encoder: encoder)
        }
      }
      
    }
    .eraseToAnyParserPrinter()
  }
}

fileprivate func densityRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.Density> {
  
  Route(.memberwise(Route2.MoistAir.Route.Density.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.Density.Route.humidityRatio)) {
        Body(
          .json(
            Route2.MoistAir.Route.Density.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.Density.Route.relativeHumidity)) {
        Body(
          .json(
            Route2.MoistAir.Route.Density.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.Density.Route.specificVolume)) {
        Body(
          .json(
            Route2.MoistAir.Route.Density.Route.SpecificVolume.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func dewPointRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.DewPoint> {
  Route(.memberwise(Route2.MoistAir.Route.DewPoint.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.DewPoint.Route.temperature)) {
        Body(
          .json(
            Route2.MoistAir.Route.DewPoint.Route.Temperature.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.DewPoint.Route.vaporPressure)) {
        Body(
          .json(
            Route2.MoistAir.Route.DewPoint.Route.VaporPressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.DewPoint.Route.wetBulb)) {
        Body(
          .json(
            Route2.MoistAir.Route.DewPoint.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func enthalpyRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.Enthalpy> {
  Route(.memberwise(Route2.MoistAir.Route.Enthalpy.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.Enthalpy.Route.altitude)) {
        Body(
          .json(
            Route2.MoistAir.Route.Enthalpy.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.Enthalpy.Route.totalPressure)) {
        Body(
          .json(
            Route2.MoistAir.Route.Enthalpy.Route.Pressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func grainsOfMoistureRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.GrainsOfMoisture> {
  Route(.memberwise(Route2.MoistAir.Route.GrainsOfMoisture.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.GrainsOfMoisture.Route.altitude)) {
        Body(
          .json(
            Route2.MoistAir.Route.GrainsOfMoisture.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.GrainsOfMoisture.Route.temperature)) {
        Body(
          .json(
            Route2.MoistAir.Route.GrainsOfMoisture.Route.Temperature.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.GrainsOfMoisture.Route.totalPressure)) {
        Body(
          .json(
            Route2.MoistAir.Route.GrainsOfMoisture.Route.Pressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func humidityRatioRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.HumidityRatio> {
  Route(.memberwise(Route2.MoistAir.Route.HumidityRatio.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.dewPoint)) {
        Body(
          .json(
            Route2.MoistAir.Route.HumidityRatio.Route.DewPoint.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.enthalpy)) {
        Body(
          .json(
            Route2.MoistAir.Route.HumidityRatio.Route.Enthalpy.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.pressure)) {
        Route(.memberwise(Route2.MoistAir.Route.HumidityRatio.Route.Pressure.init(route:))) {
          OneOf {
            Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.Pressure.Route.saturation)) {
              Body(
                .json(
                  Route2.MoistAir.Route.HumidityRatio.Route.Pressure.Route.Saturation.self,
                  decoder: decoder,
                  encoder: encoder
                )
              )
            }
            Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.Pressure.Route.vapor)) {
              Body(
                .json(
                  Route2.MoistAir.Route.HumidityRatio.Route.Pressure.Route.Vapor.self,
                  decoder: decoder,
                  encoder: encoder
                )
              )
            }
          }
        }
      }
      Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.specificHumidity)) {
        Body(
          .json(
            Route2.MoistAir.Route.HumidityRatio.Route.SpecificHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.HumidityRatio.Route.wetBulb)) {
        Body(
          .json(
            Route2.MoistAir.Route.HumidityRatio.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func psychrometricsRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.Psychrometrics> {
  Route(.memberwise(Route2.MoistAir.Route.Psychrometrics.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.Psychrometrics.Route.dewPoint)) {
        Body(
          .json(
            Route2.MoistAir.Route.Psychrometrics.Route.DewPoint.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.Psychrometrics.Route.relativeHumidity)) {
        Body(
          .json(
            Route2.MoistAir.Route.Psychrometrics.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.Psychrometrics.Route.wetBulb)) {
        Body(
          .json(
            Route2.MoistAir.Route.Psychrometrics.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

fileprivate func relativeHumidityRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.RelativeHumidity> {
  Route(.memberwise(Route2.MoistAir.Route.RelativeHumidity.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.RelativeHumidity.Route.humidityRatio)) {
        Body(
          .json(
            Route2.MoistAir.Route.RelativeHumidity.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.RelativeHumidity.Route.vaporPressure)) {
        Body(
          .json(
            Route2.MoistAir.Route.RelativeHumidity.Route.VaporPressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

func specificVolumeRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.SpecificVolume> {
  Route(.memberwise(Route2.MoistAir.Route.SpecificVolume.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.SpecificVolume.Route.altitude)) {
        Body(
          .json(
            Route2.MoistAir.Route.SpecificVolume.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.SpecificVolume.Route.humidityRatio)) {
        Body(
          .json(
            Route2.MoistAir.Route.SpecificVolume.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.MoistAir.Route.SpecificVolume.Route.relativeHumidity)) {
        Body(
          .json(
            Route2.MoistAir.Route.SpecificVolume.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

func vaporPressureRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.VaporPressure> {
  Route(.memberwise(Route2.MoistAir.Route.VaporPressure.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.VaporPressure.Route.humidityRatio)) {
        Body(
          .json(
            Route2.MoistAir.Route.VaporPressure.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}

func wetBulbRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.MoistAir.Route.WetBulb> {
  Route(.memberwise(Route2.MoistAir.Route.WetBulb.init(route:))) {
    Method.post
    OneOf {
      Route(.case(Route2.MoistAir.Route.WetBulb.Route.relativeHumidity)) {
        Body(
          .json(
            Route2.MoistAir.Route.WetBulb.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}
