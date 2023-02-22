import Foundation
import SharedModels
import URLRouting
 
func moistAirRouter(decoder: JSONDecoder, encoder: JSONEncoder) -> AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route> {
  
  var moistAirDensityRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.Density.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Density.Route.humidityRatio)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Density.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Density.Route.relativeHumidity)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Density.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Density.Route.specificVolume)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Density.Route.SpecificVolume.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirDewPointRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.temperature)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.Temperature.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.vaporPressure)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.VaporPressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.wetBulb)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.DewPoint.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirEnthalpyRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route.altitude)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route.totalPressure)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Enthalpy.Route.Pressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirGrainsOfMoistureRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.altitude)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      // This has to be before `temperature` because the signatures are close to each other, so
      // it will succeed earlier than this route.
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.totalPressure)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.Pressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.temperature)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.GrainsOfMoisture.Route.Temperature.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirHumidityRatio: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.dewPoint)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.DewPoint.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.enthalpy)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.Enthalpy.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.pressure)) {
        OneOf {
          Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.Pressure.Route.saturation)) {
            Method.post
            Body(
              .json(
                ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.Pressure.Route.Saturation.self,
                decoder: decoder,
                encoder: encoder
              )
            )
          }
          Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.Pressure.Route.vapor)) {
            Method.post
            Body(
              .json(
                ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.Pressure.Route.Vapor.self,
                decoder: decoder,
                encoder: encoder
              )
            )
          }
        }
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.specificHumidity)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.SpecificHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.wetBulb)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.HumidityRatio.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirPsychrometricsRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.altitude)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.dewPoint)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.DewPoint.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.relativeHumidity)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.wetBulb)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.Psychrometrics.Route.WetBulb.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirRelativeHumidityRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route.humidityRatio)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route.vaporPressure)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.RelativeHumidity.Route.VaporPressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirSpecificVolumeRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.altitude)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.humidityRatio)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.relativeHumidity)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.SpecificVolume.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirVaporPressureRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.VaporPressure.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.VaporPressure.Route.humidityRatio)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.VaporPressure.Route.HumidityRatio.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  var moistAirWetBulbRouter: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.MoistAir.Route.WetBulb.Route> {
    OneOf {
      Route(.case(ServerRoute.Api.Route.MoistAir.Route.WetBulb.Route.relativeHumidity)) {
        Method.post
        Body(
          .json(
            ServerRoute.Api.Route.MoistAir.Route.WetBulb.Route.RelativeHumidity.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  return OneOf {
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.density)) {
      Path(.density)
      moistAirDensityRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.dewPoint)) {
      Path(.dewPoint)
      moistAirDewPointRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.enthalpy)) {
      Path(.enthalpy)
      moistAirEnthalpyRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.grainsOfMoisture)) {
      Path(.grainsOfMoisture)
      moistAirGrainsOfMoistureRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.humidityRatio)) {
      Path(.humidityRatio)
      moistAirHumidityRatio
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.psychrometrics)) {
      Path(.psychrometrics)
      moistAirPsychrometricsRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.relativeHumidity)) {
      Path(.relativeHumidity)
      moistAirRelativeHumidityRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.specificVolume)) {
      Path(.specificVolume)
      moistAirSpecificVolumeRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.vaporPressure)) {
      Path(.vaporPressure)
      moistAirVaporPressureRouter
    }
    Route(.case(ServerRoute.Api.Route.MoistAir.Route.wetBulb)) {
      Path(.wetBulb)
      moistAirWetBulbRouter
    }
  }
  .eraseToAnyParserPrinter()
}

