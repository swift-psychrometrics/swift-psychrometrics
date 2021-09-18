//
//  TemperatureConversionTests.swift
//  UnitConversionsTests
//
//  Created by Michael Housh on 10/4/17.
//
import XCTest
@testable import Temperature

class TemperatureTests: XCTestCase {
  
  func testTemperatureConversionToFahrenheit() {
    let celsius = Temperature.celsius(75)
    XCTAssertEqual(round(celsius.fahrenheit), 167)
    
    let kelvin = Temperature.kelvin(75)
    XCTAssertEqual(round(kelvin.fahrenheit), -325)
    
    let rankine = Temperature.rankine(75)
    XCTAssertEqual(round(rankine.fahrenheit), -385)
    
    XCTAssertEqual(Temperature.fahrenheit(75).fahrenheit, 75)
    XCTAssertEqual(Temperature.fahrenheit(75).unit.rawValue, 75)
  }
  
  func testConversionToCelsius() {
    let fahrenheit = Temperature(.fahrenheit(75.0))
    XCTAssertEqual(round(fahrenheit.celsius), 24)
    
    let kelvin = Temperature(.kelvin(75))
    XCTAssertEqual(round(kelvin.celsius), -198)
    
    let rankine = Temperature(.rankine(75))
    XCTAssertEqual(round(rankine.celsius), -231)
    
    XCTAssertEqual(Temperature(.celsius(75)).celsius, 75)
    XCTAssertEqual(Temperature(.celsius(75)).unit.rawValue, 75)
  }

  func testConversionToKelvin() {
    let fahrenheit = Temperature(.fahrenheit(75.0))
    XCTAssertEqual(round(fahrenheit.kelvin), 297)

    let celsius = Temperature(.celsius(75))
    XCTAssertEqual(round(celsius.kelvin), 348)

    let rankine = Temperature(.rankine(75))
    XCTAssertEqual(round(rankine.kelvin), 42)
    
    XCTAssertEqual(Temperature(.rankine(75)).rankine, 75)
    XCTAssertEqual(Temperature(.rankine(75)).unit.rawValue, 75)
  }

  func testConversionToRankine() {
    let fahrenheit = Temperature(.fahrenheit(75.0))
    XCTAssertEqual(round(fahrenheit.rankine), 535)
    
    let celsius = Temperature(.celsius(75))
    XCTAssertEqual(round(celsius.rankine), 627)
    
    let kelvin = Temperature(.kelvin(75))
    XCTAssertEqual(round(kelvin.rankine), 135)
    
    XCTAssertEqual(Temperature(.kelvin(75)).kelvin, 75)
    XCTAssertEqual(Temperature(.kelvin(75)).unit.rawValue, 75)
  }
  
  func test_numeric_operations() {
    var temperature: Temperature = 75
    XCTAssertEqual(temperature.unit, .fahrenheit(75))
    XCTAssertEqual(temperature + 10, Temperature.fahrenheit(85))
    XCTAssertEqual(temperature * 2.0, .fahrenheit(150))
    temperature += 10
    XCTAssertEqual(temperature.fahrenheit, 85)
    temperature *= 2
    XCTAssertEqual(temperature.fahrenheit, 170)
  }

  func test_times_equal_operations() {
    var celsius = Temperature.celsius(10)
    celsius *= .celsius(10)
    XCTAssertEqual(celsius.celsius, 100)
    
    var fahrenheit = Temperature.fahrenheit(10)
    fahrenheit *= 10
    XCTAssertEqual(fahrenheit.fahrenheit, 100)
    
    var kelvin = Temperature.kelvin(10)
    kelvin *= .kelvin(10)
    XCTAssertEqual(kelvin.kelvin, 100)
    
    var rankine = Temperature.rankine(10)
    rankine *= .rankine(10)
    XCTAssertEqual(rankine.rankine, 100)
  }
  
  func test_times_operations() {
    XCTAssertEqual(Temperature.celsius(10) * .celsius(10), .celsius(100))
    XCTAssertEqual(Temperature.fahrenheit(10) * .fahrenheit(10), .fahrenheit(100))
    XCTAssertEqual(Temperature.kelvin(10) * .kelvin(10), .kelvin(100))
    XCTAssertEqual(Temperature.rankine(10) * .rankine(10), .rankine(100))
  }
  
  func test_magnitude() {
    XCTAssertEqual(Temperature.celsius(10).magnitude, 10.0.magnitude)
    XCTAssertEqual(Temperature.fahrenheit(10).magnitude, 10.0.magnitude)
    XCTAssertEqual(Temperature.kelvin(10).magnitude, 10.0.magnitude)
    XCTAssertEqual(Temperature.rankine(10).magnitude, 10.0.magnitude)
  }
  
  func test_add_operations() {
    XCTAssertEqual(Temperature.celsius(10) + .celsius(10), .celsius(20))
    XCTAssertEqual(Temperature.fahrenheit(10) + .fahrenheit(10), .fahrenheit(20))
    XCTAssertEqual(Temperature.kelvin(10) + .kelvin(10), .kelvin(20))
    XCTAssertEqual(Temperature.rankine(10) + .rankine(10), .rankine(20))
  }
  
  func test_subtract_operations() {
    XCTAssertEqual(Temperature.celsius(10) - .celsius(5), .celsius(5))
    XCTAssertEqual(Temperature.fahrenheit(10) - .fahrenheit(5), .fahrenheit(5))
    XCTAssertEqual(Temperature.kelvin(10) - .kelvin(5), .kelvin(5))
    XCTAssertEqual(Temperature.rankine(10) - .rankine(5), .rankine(5))
  }
  
  func test_comparable() {
    XCTAssert(Temperature.celsius(10) < .celsius(20))
    XCTAssert(Temperature.fahrenheit(10) > .zero)
    XCTAssert(Temperature.kelvin(10) < .kelvin(20))
    XCTAssert(Temperature.rankine(10) < .rankine(20))
  }
  
  func test_init_exactly() {
    let exactly = Temperature(exactly: 10)
    XCTAssertNotNil(exactly)
    XCTAssertEqual(exactly, .fahrenheit(10))
  }
}
