import Foundation
import SharedModels
import URLRouting

func apiRouter(decoder: JSONDecoder, encoder: JSONEncoder) -> AnyParserPrinter<URLRequestData, ServerRoute.Api.Route> {
  OneOf {
    Route(.case(ServerRoute.Api.Route.dryAir)) {
      Path(.dryAir)
      dryAirRouter(decoder: decoder, encoder: encoder)
    }
    Route(.case(ServerRoute.Api.Route.moistAir)) {
      Path(.moistAir)
      moistAirRouter(decoder: decoder, encoder: encoder)
    }
    Route(.case(ServerRoute.Api.Route.water)) {
      Path(.water)
      waterRouter(decoder: decoder, encoder: encoder)
    }
  }
  .eraseToAnyParserPrinter()
}
