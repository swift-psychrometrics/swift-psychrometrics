import XCTest
import ApiMiddlewareLive
import Dependencies
import SharedModels
import SiteMiddleware
import TestSupport

final class MoistAirApiTests: XCTestCase {
  
  override func invokeTest() {
    withDependencies {
      $0.apiMiddleware = .liveValue
    } operation: {
      super.invokeTest()
    }
  }
  
  func test_density_humidityRatio() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.density(.humidityRatio(.init(
      dryBulb: 77,
      humidityRatio: 0.02,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<MoistAir>>.self
    )
    
    XCTApproximatelyEqual(
      sut.result,
      0.073,
      tolerance: 0.0003
    )
  }
  
  func test_density_relativeHumidity() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.density(.relativeHumidity(.init(
      dryBulb: 75,
      humidity: 50,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<MoistAir>>.self
    )
    
    XCTApproximatelyEqual(
      sut.result,
      0.072683,
      tolerance: 0.0003
    )
  }
  
  func test_density_specificVolume() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.density(.specificVolume(.init(
      humidityRatio: 0.02,
      specificVolume: 12
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DensityOf<MoistAir>>.self
    )
    
    XCTApproximatelyEqual(
      sut.result,
      0.085,
      tolerance: 0.0003
    )
  }
  
  func test_dewPoint_temperature() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.dewPoint(.temperature(.init(
      dryBulb: 75,
      humidity: 50%
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DewPoint>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      55.18152621
    )
  }
  
  func test_dewPoint_vaporPressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.dewPoint(.vaporPressure(.init(
      dryBulb: 75,
      vaporPressure: 0.215
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DewPoint>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      55.176,
      tolerance: 0.001
    )
  }
  
  func test_dewPoint_wetBulb() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.dewPoint(.wetBulb(.init(
      dryBulb: 75,
      totalPressure: 14.696,
      wetBulb: 62
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<DewPoint>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      55.259,
      tolerance: 0.001
    )
  }
  
  func test_enthalpy_altitude() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.enthalpy(.altitude(.init(
      altitude: .seaLevel,
      dryBulb: 75,
      humidity: 50
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<MoistAirEnthalpy>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      28.107,
      tolerance: 0.001
    )
  }
  
  func test_enthalpy_totalPressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.enthalpy(.totalPressure(.init(
      dryBulb: 75,
      humidity: 50,
      totalPressure: 14.969
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<MoistAirEnthalpy>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      27.919,
      tolerance: 0.001
    )
  }
  
  func test_grains_altitude() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.altitude(.init(
      altitude: .seaLevel,
      dryBulb: 75,
      humidity: 50%
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<GrainsOfMoisture>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      65.905,
      tolerance: 0.001
    )
  }
  
  func test_grains_temperature() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.temperature(.init(
      dryBulb: 75,
      humidity: 50
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<GrainsOfMoisture>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      65.905,
      tolerance: 0.001
    )
  }
  
  func test_grains_totalPressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.totalPressure(.init(
      dryBulb: 75,
      humidity: 50%,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<GrainsOfMoisture>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      65.905,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_dewPoint() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.dewPoint(.init(
      dewPoint: 55,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.009,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_enthalpy() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.enthalpy(.init(
      dryBulb: 75,
      enthalpy: 28.107
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.009,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_pressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.pressure(.saturation(.init(
      totalPressure: 14.696,
      saturationPressure: 0.493
    )))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.0215,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_presure_vapor() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.pressure(.vapor(.init(
      totalPressure: 14.696,
      vaporPressure: 0.215
    )))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.009,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_specificHumidity() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.specificHumidity(.init(specificHumidity: 0.02))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.0204,
      tolerance: 0.001
    )
  }
  
  func test_humidityRatio_wetBulb() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.humidityRatio(.wetBulb(.init(
      dryBulb: 75,
      totalPressure: 14.696,
      wetBulb: 62
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<HumidityRatio>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.rawValue,
      0.009,
      tolerance: 0.001
    )
  }
  
  func test_psychrometrics_altitude() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.psychrometrics(.altitude(.init(
      altitude: .seaLevel,
      dryBulb: 75,
      humidity: 50%
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<PsychrometricResponse>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.degreeOfSaturation,
      0.493,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.enthalpy.rawValue,
      28.107,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.dewPoint.rawValue,
      55.182,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.density.rawValue,
      0.073,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.humidityRatio.rawValue,
      0.009,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.volume.rawValue,
      13.679,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.vaporPressure.rawValue,
      0.215,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.wetBulb.rawValue,
      61.957,
      tolerance: 0.001
    )
  }
  
  func test_psychrometrics_dewPoint() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.psychrometrics(.dewPoint(.init(
      dewPoint: 55.182,
      dryBulb: 75,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<PsychrometricResponse>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.degreeOfSaturation,
      0.493,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.enthalpy.rawValue,
      28.107,
      tolerance: 0.03
    )
    XCTApproximatelyEqual(
      sut.result.dewPoint.rawValue,
      55.182,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.density.rawValue,
      0.073,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.humidityRatio.rawValue,
      0.009,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.volume.rawValue,
      13.679,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.vaporPressure.rawValue,
      0.215,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.wetBulb.rawValue,
      61.957,
      tolerance: 0.04
    )
  }
  
  func test_psychrometrics_relativeHumidity() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.psychrometrics(.relativeHumidity(.init(
      dryBulb: 75,
      humidity: 50%,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<PsychrometricResponse>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.degreeOfSaturation,
      0.493,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.enthalpy.rawValue,
      28.107,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.dewPoint.rawValue,
      55.182,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.density.rawValue,
      0.073,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.humidityRatio.rawValue,
      0.009,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.volume.rawValue,
      13.679,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.vaporPressure.rawValue,
      0.215,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.wetBulb.rawValue,
      61.957,
      tolerance: 0.001
    )
  }
  
  func test_psychrometrics_wetBulb() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.psychrometrics(.wetBulb(.init(
      dryBulb: 75,
      totalPressure: 14.696,
      wetBulb: 61.957
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<PsychrometricResponse>.self
    )
    
    XCTApproximatelyEqual(
      sut.result.degreeOfSaturation,
      0.493,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.enthalpy.rawValue,
      28.107,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.dewPoint.rawValue,
      55.182,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.density.rawValue,
      0.073,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.humidityRatio.rawValue,
      0.009,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.volume.rawValue,
      13.679,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.vaporPressure.rawValue,
      0.215,
      tolerance: 0.001
    )
    XCTApproximatelyEqual(
      sut.result.wetBulb.rawValue,
      61.957,
      tolerance: 0.001
    )
  }
  
  func test_relativeHumidity_humidityRatio() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.relativeHumidity(.humidityRatio(.init(
      dryBulb: 75,
      humidityRatio: 0.009,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<RelativeHumidity>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      48.742,
      tolerance: 0.001
    )
  }
  
  func test_relativeHumidity_vaporPressure() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.relativeHumidity(.vaporPressure(.init(
      dryBulb: 75,
      vaporPressure: 0.215
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<RelativeHumidity>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      49.991,
      tolerance: 0.001
    )
  }
  
  func test_specificVolume_altitude() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.specificVolume(.altitude(.init(
      altitude: .seaLevel,
      dryBulb: 75,
      humidity: 50%
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<SpecificVolume<MoistAir>>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue,
      13.885,
      tolerance: 0.001
    )
  }
  
  func test_specificVolume_humidityRatio() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.specificVolume(.humidityRatio(.init(
      dryBulb: 75,
      humidityRatio: 0.009,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<SpecificVolume<MoistAir>>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue,
      13.674,
      tolerance: 0.001
    )
  }
  
  func test_specificVolume_relativeHumidity() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.specificVolume(.relativeHumidity(.init(
      dryBulb: 75,
      humidity: 50%,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<SpecificVolume<MoistAir>>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue,
      13.885,
      tolerance: 0.001
    )
  }
  
  func test_vaporPressure_humidityRatio() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.vaporPressure(.humidityRatio(.init(
      humidityRatio: 0.009,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<VaporPressure>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      0.209,
      tolerance: 0.001
    )
  }
  
  func test_wetBulb_relativeHumidity() async throws {
    @Dependency(\.siteMiddleware) var middleware
    
    let route = ServerRoute.Api.Route.moistAir(.wetBulb(.relativeHumidity(.init(
      dryBulb: 75,
      humidity: 50%,
      totalPressure: 14.696
    ))))
    let sut = try await middleware.apiRespond(
      route: .init(isDebug: true, route: route),
      as: ResultEnvelope<WetBulb>.self
    )
    XCTApproximatelyEqual(
      sut.result.rawValue.rawValue,
      61.957,
      tolerance: 0.001
    )
  }
}

