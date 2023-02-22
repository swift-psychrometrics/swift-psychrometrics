import Foundation
import SharedModels
import URLRouting

func waterRouter(decoder: JSONDecoder, encoder: JSONEncoder) -> AnyParserPrinter<URLRequestData, ServerRoute.Api.Route.Water.Route> {
  OneOf {
    Route(.case(ServerRoute.Api.Route.Water.Route.density)) {
      Path(.density)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Water.Route.Density.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
    Route(.case(ServerRoute.Api.Route.Water.Route.specificHeat)) {
      Path(.specificHeat)
      Method.post
      Body(
        .json(
          ServerRoute.Api.Route.Water.Route.SpecificHeat.self,
          decoder: decoder,
          encoder: encoder
        )
      )
    }
  }
  .eraseToAnyParserPrinter()
}
