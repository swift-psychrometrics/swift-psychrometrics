import ApiMiddleware
import Dependencies
import SharedModels
import Vapor

extension SiteMiddleware: DependencyKey {
  
  public static var liveValue: SiteMiddleware {
    @Dependency(\.apiMiddleware) var apiMiddleware
    return .live(apiMiddleware: apiMiddleware)
  }
  
  public static func live(apiMiddleware: ApiMiddleware) -> Self {
    .init(
      respond: { request, route in
        switch route {
        case let .api(api):
          return try await apiMiddleware.respond(api).eraseToAnyAsyncEncodable()
        }
      }
    )
  }
}

struct _AnyEncodable: Encodable {
  let value: any Encodable
  
  func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
}

extension _AnyEncodable: AsyncResponseEncodable {
  func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
    let response = Response()
    response.headers.contentType = .json
    response.body = Response.Body(data: try JSONEncoder().encode(self))
    return response
  }
}

extension Encodable {
  func eraseToAnyAsyncEncodable() -> _AnyEncodable {
    .init(value: self)
  }
}
