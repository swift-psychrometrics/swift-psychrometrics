import Dependencies
import SharedModels
import Vapor
import XCTestDynamicOverlay

public struct SiteMiddleware {

  public var respond: (Request, ServerRoute) async throws -> AsyncResponseEncodable

  public init(
    respond: @escaping (Request, ServerRoute) async throws -> AsyncResponseEncodable
  ) {
    self.respond = respond
  }
}

extension SiteMiddleware: TestDependencyKey {
  public static let testValue: SiteMiddleware = .init(
    respond: unimplemented("\(Self.self).respond"))
}

extension DependencyValues {
  public var siteMiddleware: SiteMiddleware {
    get { self[SiteMiddleware.self] }
    set { self[SiteMiddleware.self] = newValue }
  }
}
