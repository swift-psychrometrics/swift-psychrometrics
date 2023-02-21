import Foundation
import SharedModels
import URLRouting

struct DryAirRouter: SiteRouteRouter {
  
  typealias SiteRoute = Route2.DryAir
  
  let decoder: JSONDecoder
  let encoder: JSONEncoder
  
  @ParserBuilder
  var body: AnyParserPrinter<URLRequestData, Route2.DryAir> {
    Route(.memberwise(Route2.DryAir.init(route:))) {
      Path(.dryAir)
      OneOf {
        Route(.case(Route2.DryAir.Route.density)) {
          densityRouter(decoder: decoder, encoder: encoder)
        }
        Route(.case(Route2.DryAir.Route.enthalpy)) {
          Path(.enthalpy)
          Method.post
          Body(
            .json(
              Route2.DryAir.Route.Enthalpy.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
        Route(.case(Route2.DryAir.Route.specificVolume)) {
          Path(.specificVolume)
          Method.post
          Body(
            .json(
              Route2.DryAir.Route.SpecificVolume.self,
              decoder: decoder,
              encoder: encoder
            )
          )
        }
      }
    }
    .eraseToAnyParserPrinter()
  }
}

fileprivate func densityRouter(
  decoder: JSONDecoder,
  encoder: JSONEncoder
) -> AnyParserPrinter<URLRequestData, Route2.DryAir.Route.Density> {
  Route(.memberwise(Route2.DryAir.Route.Density.init(route:))) {
    Path(.density)
    Method.post
    OneOf {
      Route(.case(Route2.DryAir.Route.Density.Route.altitude)) {
        Body(
          .json(
            Route2.DryAir.Route.Density.Route.Altitude.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
      Route(.case(Route2.DryAir.Route.Density.Route.totalPressure)) {
        Body(
          .json(
            Route2.DryAir.Route.Density.Route.Pressure.self,
            decoder: decoder,
            encoder: encoder
          )
        )
      }
    }
  }
  .eraseToAnyParserPrinter()
}
