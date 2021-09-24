import XCTest
@testable import CoreUnitTypes

final class LengthTests: XCTestCase {
  
  func test_converting_to_centimeters() {
    XCTAssertEqual(Length.centimeters(75).centimeters, 75)
    XCTAssertEqual(round(Length.feet(75).centimeters), 2286)
    XCTAssertEqual(round(Length.inches(75).centimeters), 191)
    XCTAssertEqual(round(Length.meters(75).centimeters), 7500)
    
    var length = Length.centimeters(10)
    length.centimeters = 20
    XCTAssertEqual(length.centimeters, 20)
  }
  
  func test_converting_to_feet() {
    XCTAssertEqual(round(Length.centimeters(75).feet), 2)
    XCTAssertEqual(round(Length.feet(75).feet), 75)
    XCTAssertEqual(round(Length.inches(75).feet), 6)
    XCTAssertEqual(round(Length.meters(75).feet), 246)
    
    var length = Length.feet(10)
    length.feet = 20
    XCTAssertEqual(length.feet, 20)
  }
  
  func test_converting_to_inches() {
    XCTAssertEqual(round(Length.centimeters(75).inches), 30)
    XCTAssertEqual(round(Length.feet(75).inches), 900)
    XCTAssertEqual(round(Length.inches(75).inches), 75)
    XCTAssertEqual(round(Length.meters(75).inches), 2953)
    
    var length = Length.inches(10)
    length.inches = 20
    XCTAssertEqual(length.inches, 20)
  }
  
  func test_converting_to_meters() {
    XCTAssertEqual(Length.centimeters(75).meters, 0.75)
    XCTAssertEqual(round(Length.feet(75).meters), 23)
    XCTAssertEqual(round(Length.inches(75).meters), 2)
    XCTAssertEqual(round(Length.meters(75).meters), 75)
    
    var length = Length.meters(10)
    length.meters = 20
    XCTAssertEqual(length.meters, 20)
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
  
//  func test_with_different_default_units() {
//    Length.Unit.default = .centimeters
//    let centimeters: Length = 100
//    XCTAssertEqual(centimeters.centimeters, 100)
//    
//    Length.Unit.default = .inches
//    let inches: Length = 100.0
//    XCTAssertEqual(inches.inches, 100)
//    
//    Length.Unit.default = .meters
//    let meters: Length = 100
//    XCTAssertEqual(meters.meters, 100)
//    
//    Length.Unit.default = .feet
//  }
  
  func test_LengthUnit_symbols() {
    XCTAssertEqual(Length.Unit.centimeters.symbol, "cm")
    XCTAssertEqual(Length.Unit.meters.symbol, "m")
    XCTAssertEqual(Length.Unit.feet.symbol, "ft")
    XCTAssertEqual(Length.Unit.inches.symbol, "in")
  }
  
  func test_Addition_And_Subtraction() {
    var length: Length = 10 + 10
    XCTAssertEqual(length.feet, 20)
    length -= 10
    XCTAssertEqual(length.feet, 10)
  }
  
  func test_Multiplication() {
    var length: Length = 10 * 10
    XCTAssertEqual(length.feet, 100)
    length *= 2
    XCTAssertEqual(length.feet, 200)
  }
  
  func test_Comparable() {
    XCTAssertTrue(Length.feet(10) > 5)
  }
  
//  func test_magnitude() {
//    let length = Length(exactly: 100)!
//    XCTAssertEqual(length.magnitude, Double(100).magnitude)
//  }
  
  func test_LengthUnit_lengthKeyPath() {
    var length: Length = .centimeters(10)
    XCTAssertEqual(length[.centimeters], 10)
    
    length = .meters(10)
    XCTAssertEqual(length[.meters], 10)
    
    length = .inches(10)
    XCTAssertEqual(length[.inches], 10)
    
    length = .feet(10)
    XCTAssertEqual(length[.feet], 10)
    
  }
}
