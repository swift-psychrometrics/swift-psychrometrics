import XCTest
import ApiMiddlewareLive
import Dependencies
import SharedModels
import SiteMiddleware
import TestSupport

final class DryAirApiTests: XCTestCase {
  
  override func invokeTest() {
    withDependencies {
      $0.apiMiddleware = .liveValue
    } operation: {
      super.invokeTest()
    }
  }
  
  func test_density_altitude() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.dryAir(.density(.altitude(
      .init(altitude: .seaLevel, dryBulb: .fahrenheit(60))
    )))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<DryAir>>.self
    )
    XCTAssertEqual(
      round(sut.result.rawValue * 1000) / 1000,
      0.076
    )
  }
  
  func test_density_pressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.dryAir(.density(.totalPressure(
      .init(dryBulb: 60, totalPressure: 14.696)
    )))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<DryAir>>.self
    )
    XCTAssertEqual(
      round(sut.result.rawValue * 1000) / 1000,
      0.076
    )
  }
  
  func test_enthalpy() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.dryAir(.enthalpy(.init(dryBulb: 77)))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DryAirEnthalpy>.self
    )
    XCTAssertEqual(
      round(sut.result.rawValue.rawValue * 1000) / 1000,
      18.48
    )
  }
  
  func test_specificVolume() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.dryAir(.specificVolume(
      .init(dryBulb: 77, totalPressure: 14.696)
    ))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<SpecificVolume<DryAir>>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue,
      13.5251,
      tolerance: 0.0047
    )
  }
}
