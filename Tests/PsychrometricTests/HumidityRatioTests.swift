import Dependencies
import PsychrometricClientLive
import SharedModels
import TestSupport
import XCTest

final class HumidityRatioTests: PsychrometricTestCase {
  
  func test_humidityRatio_as_mass() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let ratio = try await client.humidityRatio(.mass(water: 14.7, dryAir: 18.3))
    
    XCTAssertEqual(
      round(ratio.rawValue * 100) / 100,
      0.50
    )
  }
  
  func test_humidityRatio_and_partialPressure() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let partialPressure = try await client.vaporPressure(.relativeHumidity(50%, dryBulb: 75))
    
    let humidityRatio = try await client.humidityRatio(.totalPressure(
      .init(altitude: .seaLevel),
      partialPressure: partialPressure
    ))
    
    XCTAssertEqual(round(humidityRatio.rawValue * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
  }
  
  func test_humidityRatio_and_vapor_pressure() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    // conditions at 77°F and standard pressure at 1000'
    let ratio = try await client.humidityRatio(.totalPressure(
      14.175,
      vaporPressure: 0.45973
    ))
    XCTApproximatelyEqual(ratio.rawValue, 0.020847)
    
    let vaporPressure = try await client.vaporPressure(.humidityRatio(ratio, totalPressure: 14.175))
    XCTApproximatelyEqual(vaporPressure, 0.45973)
  }
  
  func test_humidity_ratio_at_different_conditions_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let values: [(DryBulb, HumidityRatio, Double)] = [
      (-58, 0.0000243, 0.01),
      (-4, 0.0006373, 0.01),
      (23, 0.0024863, 0.005),
      (41, 0.005425, 0.005),
      (77, 0.02173, 0.005),
      (122, 0.086863, 0.01),
      (185, 0.838105, 0.02)
    ]
    
    for (temp, expected, diff) in values {
      let ratio = try await client.humidityRatio(.dryBulb(temp, totalPressure: 14.696))
      XCTApproximatelyEqual(ratio.rawValue.rawValue, expected.rawValue.rawValue, tolerance: diff)
    }
  }
  
  func test_humidity_ratio_at_different_conditions_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let values: [(Double, HumidityRatio, Double)] = [
      (-50, 0.0000243, 0.01),
      (-20, 0.0006373, 0.01),
      (-5, 0.0024863, 0.005),
      (5, 0.005425, 0.005),
      (25, 0.02173, 0.005),
      (50, 0.086863, 0.01),
      (85, 0.838105, 0.02)
    ]
    
    for (temp, expected, diff) in values {
      let ratio = try await client.humidityRatio(.dryBulb(
        .celsius(temp),
        totalPressure: .pascals(101325),
        units: .metric
      ))
      XCTApproximatelyEqual(ratio.rawValue.rawValue, expected.rawValue.rawValue, tolerance: diff)
    }
  }

  func test_humidityRatio_and_relativeHumidity_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let relativeHumidity = try await client.relativeHumidity(.totalPressure(
      14.696,
      dryBulb: 100,
      humidityRatio: 0.00523
    ))
    XCTAssertEqual(round(relativeHumidity.rawValue.rawValue), 13)
    
    let relativeHumidity2 = try await client.relativeHumidity(.dryBulb(
      100,
      humidityRatio: 0.00523,
      totalPressure: 14.696
    ))
    XCTAssertEqual(relativeHumidity, relativeHumidity2)
  }
  
  func test_humidityRatio_from_dryBulb_and_enthalpy_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let ratio = try await client.humidityRatio(.enthalpy(
      .init(.init(81316, units: .joulePerKilogram)),
      dryBulb: .celsius(30),
      units: .metric
    ))
    XCTApproximatelyEqual(ratio.rawValue, 0.02, tolerance: 0.001)
  }
}
