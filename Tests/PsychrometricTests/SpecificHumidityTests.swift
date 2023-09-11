import Dependencies
import PsychrometricClientLive
import SharedModels
import TestSupport
import XCTest

final class SpecificHumidityTests: PsychrometricTestCase {
  
  func test_specificHumidity() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let sut1 = try await client.specificHumidity(.waterMass(14.7, dryAirMass: 18.3))

    XCTAssertEqual(
      round(sut1.rawValue * 100) / 100,
      0.45
    )
    
    let temperature: DryBulb = 75
    let humidity: RelativeHumidity = 50%
    let altitude: Length = 1000
    let pressure: TotalPressure = .init(altitude: altitude)
    
    let ratio = try await client.humidityRatio(.dryBulb(
      temperature,
      relativeHumidity: 50%,
      totalPressure: pressure
    ))

    let specificyHumidity = try await client.specificHumidity(.humidityRatio(ratio, units: nil))

    XCTAssertEqual(
      round(specificyHumidity.rawValue * 100) / 100,
      0.01
    )
    
    var sut = try await client.specificHumidity(.dryBulb(
      temperature,
      relativeHumidity: humidity,
      totalPressure: pressure
    ))
    
    XCTAssertEqual(
      round(sut.rawValue * 1000) / 1000,
      0.009
    )
    
    sut = try await client.specificHumidity(.dryBulb(
      temperature,
      altitude: altitude,
      relativeHumidity: humidity
    ))
    
    XCTAssertEqual(
      round(sut.rawValue * 1000) / 1000,
      0.009
    )
  }
  
  func test_conversions_between_specificHumidity_and_humidityRatio() async throws {
    @Dependency(\.psychrometricClient) var client;

    let specific = try await client.specificHumidity(.humidityRatio(0.006, units: .imperial))
    XCTApproximatelyEqual(specific.rawValue,  0.00596421471)
    let ratio = try await client.humidityRatio(.specificHumidity(0.00596421471))
    XCTApproximatelyEqual(ratio.rawValue, 0.006)
  }
}
