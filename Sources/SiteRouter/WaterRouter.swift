import Foundation
import SharedModels
import URLRouting

struct WaterRouter: SiteRouteRouter {
  public let decoder: JSONDecoder
  public let enocder: JSONEncoder

  public init(
    decoder: JSONDecoder,
    enocder: JSONEncoder
  ) {
    self.decoder = decoder
    self.enocder = enocder
  }

  @ParserBuilder
  var body: AnyParserPrinter<URLRequestData, Route2.Water> {
    Route(.memberwise(Route2.Water.init(route:))) {
      Path(.water)
      OneOf {
        Route(.case(Route2.Water.Route.density)) {
          Path(.density)
          Method.post
          Body(
            .json(
              Route2.Water.Route.Density.self,
              decoder: self.decoder,
              encoder: self.enocder
            )
          )
        }
        Route(.case(Route2.Water.Route.specificHeat)) {
          Path(.specificHeat)
          Method.post
          Body(
            .json(
              Route2.Water.Route.SpecificHeat.self,
              decoder: self.decoder,
              encoder: self.enocder
            )
          )
        }
      }
    }
    .eraseToAnyParserPrinter()
  }

}
