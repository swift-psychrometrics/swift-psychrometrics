import Dependencies
import PsychrometricClientLive
import Psychrometrics
import SharedModels
import XCTest

final class SpecificHeatTests: PsychrometricTestCase {
  
  func test_specific_heat_of_water() async {
    @Dependency(\.psychrometricClient) var client;
    
    let specificHeat = await client.specificHeat.water(.fahrenheit(50))
    
    XCTAssertEqual(round(specificHeat.rawValue.fahrenheit * 100) / 100, 1)
  }
}
