import CasePaths
import ConcurrencyHelpers
import Dependencies
import SharedModels
//import TestSupport
import XCTestDynamicOverlay

public struct ApiMiddleware {
  public var apiResponse: (ServerRoute.Api.Route) async throws -> any Encodable
  public var respond: (ServerRoute.Api) async throws -> any Encodable

  public init(
    apiResponse: @escaping (ServerRoute.Api.Route) async throws -> any Encodable,
    respond: @escaping (ServerRoute.Api) async throws -> any Encodable
  ) {
    self.apiResponse = apiResponse
    self.respond = respond
  }
}

extension ApiMiddleware {
  public static let unimplemented = Self.init(
    apiResponse: XCTestDynamicOverlay.unimplemented("\(Self.self).apiResponse"),
    respond: XCTestDynamicOverlay.unimplemented("\(Self.self).respond")
  )

  public static let noop = Self.init(
    apiResponse: { _ in try await Task.never() },
    respond: { _ in try await Task.never() }
  )

  //  public mutating func override(
  //    route matchingRoute: ServerRoute.Api.Route,
  //    with response: @escaping @Sendable () async throws -> any Encodable
  //  ) {
  //    let fullfill = expectation(description: "route")
  //    self.apiResponse = { @Sendable [self] route in
  //      if route == matchingRoute {
  //        fullfill()
  //        return try await response()
  //      } else {
  //        return try await self.apiResponse(route)
  //      }
  //    }
  //  }
  //
  //  public mutating func override<Value>(
  //    route matchingRoute: CasePath<ServerRoute.Api.Route, Value>,
  //    with response: @escaping @Sendable (Value) async throws -> any Encodable
  //  ) {
  //    let fullfill = expectation(description: "route")
  //    self.apiResponse = { @Sendable [self] route in
  //      if let value = matchingRoute.extract(from: route) {
  //        fullfill()
  //        return try await response(value)
  //      } else {
  //        return try await self.apiResponse(route)
  //      }
  //    }
  //  }
}

extension ApiMiddleware: TestDependencyKey {

  public static var testValue: ApiMiddleware { .unimplemented }

  public static var previewValue: ApiMiddleware { Self.noop }
}

extension DependencyValues {
  public var apiMiddleware: ApiMiddleware {
    get { self[ApiMiddleware.self] }
    set { self[ApiMiddleware.self] = newValue }
  }
}
