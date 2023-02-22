import URLRouting

protocol SiteRouteRouter: ParserPrinter {

  associatedtype SiteRoute

  @ParserBuilder
  var body: AnyParserPrinter<URLRequestData, SiteRoute> { get }
}

extension SiteRouteRouter {

  public func parse(_ input: inout URLRequestData) throws -> Self.SiteRoute {
    try body.parse(input)
  }

  public func print(_ output: Self.SiteRoute, into input: inout URLRequestData) throws {
    try body.print(output, into: &input)
  }
}
