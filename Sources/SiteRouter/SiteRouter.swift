import Dependencies
import Foundation
import SharedModels
import URLRouting

public struct SiteRouter: ParserPrinter {
  
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
  var body: AnyParserPrinter<URLRequestData, ServerRoute> {
    Route(.case(ServerRoute.api)) {
      Path { "api"; "v1" }
      Parse(.memberwise(ServerRoute.Api.init(isDebug:route:))) {
        Headers {
          Field("X-DEBUG", default: false) { Bool.parser() }
        }
        apiRouter(decoder: decoder, encoder: enocder)
      }
    }
    .eraseToAnyParserPrinter()
  }
  
  public func parse(_ input: inout URLRequestData) throws -> ServerRoute {
    try body.parse(input)
  }
  
  public func print(_ output: ServerRoute, into input: inout URLRequestData) throws {
    try body.print(output, into: &input)
  }
}

public enum SiteRouterKey: DependencyKey {
  
  public static var liveValue: AnyParserPrinter<URLRequestData, ServerRoute> {
    SiteRouter(decoder: .init(), enocder: jsonEncoder)
      .eraseToAnyParserPrinter()
  }
  
  public static var testValue: AnyParserPrinter<URLRequestData, ServerRoute> {
    liveValue
  }
}

extension DependencyValues {
  public var siteRouter: AnyParserPrinter<URLRequestData, ServerRoute> {
    get { self[SiteRouterKey.self] }
    set { self[SiteRouterKey.self] = newValue}
  }
}

private let jsonEncoder: JSONEncoder = {
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
  return encoder
}()
