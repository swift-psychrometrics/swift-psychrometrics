import XCTest
@testable import Length

final class LengthTests: XCTestCase {
  
  func test_converting_to_centimeters() {
    XCTAssertEqual(Length.centimeters(75).centimeters, 75)
    XCTAssertEqual(round(Length.feet(75).centimeters), 2286)
    XCTAssertEqual(round(Length.inches(75).centimeters), 191)
    XCTAssertEqual(round(Length.meters(75).centimeters), 7500)
  }
  
  func test_converting_to_feet() {
    XCTAssertEqual(round(Length.centimeters(75).feet), 2)
    XCTAssertEqual(round(Length.feet(75).feet), 75)
    XCTAssertEqual(round(Length.inches(75).feet), 6)
    XCTAssertEqual(round(Length.meters(75).feet), 246)
  }
  
  func test_converting_to_inches() {
    XCTAssertEqual(round(Length.centimeters(75).inches), 30)
    XCTAssertEqual(round(Length.feet(75).inches), 900)
    XCTAssertEqual(round(Length.inches(75).inches), 75)
    XCTAssertEqual(round(Length.meters(75).inches), 2953)
  }
  
  func test_converting_to_meters() {
    XCTAssertEqual(Length.centimeters(75).meters, 0.75)
    XCTAssertEqual(round(Length.feet(75).meters), 23)
    XCTAssertEqual(round(Length.inches(75).meters), 2)
    XCTAssertEqual(round(Length.meters(75).meters), 75)
  }
  
  func test_default_units_are_feet() {
    let length: Length = 10
    XCTAssertEqual(length.feet, 10)
    let length2: Length = 10.1
    XCTAssertEqual(length2.feet, 10.1)
  }
  
  func test_seaLevel() {
    XCTAssertEqual(Length.seaLevel.feet, 0)
  }
  
  func test_with_different_default_units() {
    Length.defaultUnits = .centimeters
    let centimeters: Length = 100
    XCTAssertEqual(centimeters.centimeters, 100)
    
    Length.defaultUnits = .inches
    let inches: Length = 100.0
    XCTAssertEqual(inches.inches, 100)
    
    Length.defaultUnits = .meters
    let meters: Length = 100
    XCTAssertEqual(meters.meters, 100)
    
    Length.defaultUnits = .feet
  }
  
  func test_LengthUnit_symbols() {
    XCTAssertEqual(LengthUnit.centimeters.symbol, "cm")
    XCTAssertEqual(LengthUnit.meters.symbol, "m")
    XCTAssertEqual(LengthUnit.feet.symbol, "ft")
    XCTAssertEqual(LengthUnit.inches.symbol, "in")
  }
}
