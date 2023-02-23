import XCTest
import ApiMiddlewareLive
import Dependencies
import SharedModels
import SiteMiddleware
import TestSupport

final class WaterApiTests: XCTestCase {
  override func invokeTest() {
    withDependencies {
      $0.apiMiddleware = .liveValue
    } operation: {
      super.invokeTest()
    }
  }
  
  func test_density() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.water(.density(.init(dryBulb: 50)))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<Water>>.self
    )
    XCTAssertEqual(
      round(sut.result.rawValue * 100) / 100,
      62.58
    )
    
  }
  
  func test_specificHeat() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.water(.specificHeat(.init(dryBulb: 50)))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<SpecificHeat>.self
    )
    XCTAssertEqual(
      round(sut.result.rawValue.rawValue * 100) / 100,
      1
    )
    
  }
}
