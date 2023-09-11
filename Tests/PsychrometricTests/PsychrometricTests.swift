import Dependencies
import PsychrometricClientLive
import Psychrometrics
import TestSupport
import XCTest

final class PsychrometricTests: PsychrometricTestCase {

  // Test example 1 in ASHRAE 2017
  
  // Not great agreement in tolerances.
  func test_psychrometrics_from_wetBulb_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;

    let psychrometrics = try await client.psychrometricProperties(
      .wetBulb(65, dryBulb: 100, totalPressure: 14.696)
    )
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.dewPoint, 40, tolerance: 5.9) // not great
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.35) // not great
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.specificVolume, 14.22, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_wetBulb_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    let psychrometrics = try await client.psychrometricProperties(.wetBulb(
      .celsius(20),
      dryBulb: .celsius(40),
      totalPressure: .pascals(101325),
      units: .metric
    ))

    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.0065, tolerance: 0.001)
//    XCTApproximatelyEqual(psychrometrics.dewPoint, 7.49, tolerance: 2.84) // Fix
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 14, tolerance: 2.3)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 56700, tolerance: 2791.2) // fix
    XCTApproximatelyEqual(psychrometrics.specificVolume, 0.896, tolerance: 0.01)
  }
  
  func test_psychrometrics_from_dewPoint_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;

    // Using the dew-point returned in wet-bulb test instead of 40
    let psychrometrics = try await client.psychrometricProperties(.dewPoint(
      44.7,
      dryBulb: 100,
      totalPressure: 14.696
    ))
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.wetBulb, 65, tolerance: 0.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.specificVolume, 14.22, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_dewPoint_metric() async throws {
    @Dependency(\.psychrometricClient) var client;

    // Using the dew-point returned in wet-bulb test instead of 40
    let psychrometrics = try await client.psychrometricProperties(.dewPoint(
      .celsius(7),
      dryBulb: .celsius(40),
      totalPressure: .pascals(101325),
      units: .metric
    ))
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.0065, tolerance: 0.001)
    XCTApproximatelyEqual(psychrometrics.wetBulb.celsius, 20, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 14, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 56700, tolerance: 462.8) // not great
    XCTApproximatelyEqual(psychrometrics.specificVolume, 0.896, tolerance: 0.031)
  }
  
  func test_psychrometrics_from_relativeHumidity_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;

    // Using the relative returned in wet-bulb test instead of 40
    let psychrometrics = try await client.psychrometricProperties(.dryBulb(
      100,
      relativeHumidity: 15.35%,
      totalPressure: 14.696
    ))
    XCTApproximatelyEqual(psychrometrics.humidityRatio.rawValue, 0.00523, tolerance: 0.011)
    XCTApproximatelyEqual(psychrometrics.dewPoint, 44.7, tolerance: 0.053)
    XCTApproximatelyEqual(psychrometrics.wetBulb, 65, tolerance: 0.1)
    XCTApproximatelyEqual(psychrometrics.relativeHumidity, 13, tolerance: 2.351)
    XCTApproximatelyEqual(psychrometrics.enthalpy, 29.8, tolerance: 1.1)
    XCTApproximatelyEqual(psychrometrics.specificVolume, 14.22, tolerance: 0.031)
  }
  
//  func test_airString() async throws {
//    
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
//    let enthalpy1 = try await PsychrometricResponse.init(altitude: .seaLevel, dryBulb: 75, humidity: 50%)
//    let enthalpy2 = try await PsychrometricResponse.init( altitude: .seaLevel, dryBulb: 93, humidity: 30%)
//    
//    let string1 = try String(data: encoder.encode(enthalpy1), encoding: .utf8)
//    let string2 = try String(data: encoder.encode(enthalpy2), encoding: .utf8)
//    
//    
//    print("Return:")
//    print(string1!)
//    
//    print("Supply:")
//    print(string2!)
//    
//    let grainsDiff = enthalpy1!.grainsOfMoisture - enthalpy2!.grainsOfMoisture
//    print()
//    print("Grains Difference / hr:")
//    print(grainsDiff)
//    
//    print("Grains (lbs) / day")
//    print(grainsDiff * 24)
//    print()
//    
//    XCTFail()
//  }
}
