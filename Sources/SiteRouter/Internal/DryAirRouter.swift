import Foundation
import SharedModels
import URLRouting

func dryAirRouter(decoder: JSONDecoder, encoder: JSONEncoder) -> AnyParserPrinter<
  URLRequestData, ServerRoute.Api.Route.DryAir.Route
> {
  OneOf {
    Route(.case(ServerRoute.Api.Route.DryAir.Route.density)) {
      Path(.density)
      OneOf {
        Route(.case(ServerRoute.Api.Route.DryAir.Route.Density.Route.altitude)) {
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.DryAir.Route.Density.Route.Altitude.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(ServerRoute.Api.Route.DryAir.Route.Density.Route.totalPressure)) {
          Method.post
          Body(
            .json(
              ServerRoute.Api.Route.DryAir.Route.Density.Route.Pressure.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
    Route(.case(ServerRoute.Api.Route.DryAir.Route.enthalpy)) {
      Path(.enthalpy)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.DryAir.Route.Enthalpy.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.DryAir.Route.specificVolume)) {
      Path(.specificVolume)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.DryAir.Route.SpecificVolume.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  .eraseToAnyParserPrinter()
}
