import SharedModels
import XCTest

class TemperatureTests: XCTestCase {

  func testTemperatureConversionToFahrenheit() {
    let celsius = DryBulb.celsius(75)
    XCTAssertEqual(round(celsius.fahrenheit), 167)

    let kelvin = DryBulb.kelvin(75)
    XCTAssertEqual(round(kelvin.fahrenheit), -325)

    let rankine = DryBulb.rankine(75)
    XCTAssertEqual(round(rankine.fahrenheit), -385)

    XCTAssertEqual(DryBulb.fahrenheit(75).fahrenheit, 75)

    var temp = DryBulb.fahrenheit(10)
    temp.fahrenheit = 20
    XCTAssertEqual(temp.fahrenheit, 20)
  }

  func testConversionToCelsius() {
    let fahrenheit = DryBulb.fahrenheit(75.0)
    XCTAssertEqual(round(fahrenheit.celsius), 24)

    let kelvin = DryBulb.kelvin(75)
    XCTAssertEqual(round(kelvin.celsius), -198)

    let rankine = DryBulb.rankine(75)
    XCTAssertEqual(round(rankine.celsius), -231)

    var temp = DryBulb.celsius(10)
    XCTAssertEqual(temp.celsius, 10)
    temp.celsius = 20
    XCTAssertEqual(temp.celsius, 20)
  }

  func testConversionToKelvin() {
    let fahrenheit = DryBulb.fahrenheit(75.0)
    XCTAssertEqual(round(fahrenheit.kelvin), 297)

    let celsius = DryBulb.celsius(75)
    XCTAssertEqual(round(celsius.kelvin), 348)

    let rankine = DryBulb.rankine(75)
    XCTAssertEqual(round(rankine.kelvin), 42)

    var temp = DryBulb.rankine(10)
    XCTAssertEqual(temp.rankine, 10)
    temp.rankine = 20
    XCTAssertEqual(temp.rankine, 20)
  }

  func testConversionToRankine() {
    let fahrenheit = DryBulb.fahrenheit(75.0)
    XCTAssertEqual(round(fahrenheit.rankine), 535)

    let celsius = DryBulb.celsius(75)
    XCTAssertEqual(round(celsius.rankine), 627)

    let kelvin = DryBulb.kelvin(75)
    XCTAssertEqual(round(kelvin.rankine), 135)

    var temp = DryBulb.kelvin(10)
    XCTAssertEqual(temp.kelvin, 10)
    temp.kelvin = 20
    XCTAssertEqual(temp.kelvin, 20)
  }

  func test_numeric_operations() {
    var temperature: DryBulb = 75
    XCTAssertEqual(temperature.fahrenheit, 75)
    XCTAssertEqual(temperature + 10, DryBulb.fahrenheit(85))
    XCTAssertEqual(temperature + .fahrenheit(10), DryBulb.fahrenheit(85))
    XCTAssertEqual(temperature * 2, .fahrenheit(150))
    XCTAssertEqual(temperature * .fahrenheit(2), .fahrenheit(150))
    temperature += 10
    XCTAssertEqual(temperature.fahrenheit, 85)
    temperature *= 2
    XCTAssertEqual(temperature.fahrenheit, 170)
  }

  func test_times_equal_operations() {
    var celsius = DryBulb.celsius(10)
    celsius *= .celsius(10)
    XCTAssertEqual(celsius.celsius, 100)

    var fahrenheit = DryBulb.fahrenheit(10)
    fahrenheit *= 10
    XCTAssertEqual(fahrenheit.fahrenheit, 100)

    var kelvin = DryBulb.kelvin(10)
    kelvin *= .kelvin(10)
    XCTAssertEqual(kelvin.kelvin, 100)

    var rankine = DryBulb.rankine(10)
    rankine *= .rankine(10)
    XCTAssertEqual(rankine.rankine, 100)
  }

  func test_times_operations() {
    XCTAssertEqual(DryBulb.celsius(10) * .celsius(10), .celsius(100))
    XCTAssertEqual(DryBulb.fahrenheit(10) * .fahrenheit(10), .fahrenheit(100))
    XCTAssertEqual(DryBulb.kelvin(10) * .kelvin(10), .kelvin(100))
    XCTAssertEqual(DryBulb.rankine(10) * .rankine(10), .rankine(100))
  }

  func test_add_operations() {
    XCTAssertEqual(DryBulb.celsius(10) + .celsius(10), .celsius(20))
    XCTAssertEqual(DryBulb.fahrenheit(10) + .fahrenheit(10), .fahrenheit(20))
    XCTAssertEqual(DryBulb.kelvin(10) + .kelvin(10), .kelvin(20))
    XCTAssertEqual(DryBulb.rankine(10) + .rankine(10), .rankine(20))
  }

  func test_subtract_operations() {
    XCTAssertEqual(DryBulb.celsius(10) - .celsius(5), .celsius(5))
    XCTAssertEqual(DryBulb.fahrenheit(10) - .fahrenheit(5), .fahrenheit(5))
    XCTAssertEqual(DryBulb.kelvin(10) - .kelvin(5), .kelvin(5))
    XCTAssertEqual(DryBulb.rankine(10) - .rankine(5), .rankine(5))
  }

  func test_comparable() {
    XCTAssert(DryBulb.celsius(10) < .celsius(20))
    XCTAssert(DryBulb.fahrenheit(10) > .zero)
    XCTAssert(DryBulb.kelvin(10) < .kelvin(20))
    XCTAssert(DryBulb.rankine(10) < .rankine(20))
  }

  func test_init_exactly() {
    let exactly = DryBulb(exactly: 10)
    XCTAssertNotNil(exactly)
    XCTAssertEqual(exactly, .fahrenheit(10))
  }

  func test_TemperatureUnit_symbol() {
    XCTAssertEqual(TemperatureUnit.celsius.symbol, "°C")
    XCTAssertEqual(TemperatureUnit.fahrenheit.symbol, "°F")
    XCTAssertEqual(TemperatureUnit.kelvin.symbol, "°K")
    XCTAssertEqual(TemperatureUnit.rankine.symbol, "°R")
  }

  func test_atAltitude() {
    let expectations: [(Double, Double)] = [
      (0.0, 59),
      (1000, 55.4),
      (5000, 41.2),
    ]

    for (input, expected) in expectations {
      let temperature: Temperature<DryAir> = .atAltitude(.feet(input))
      XCTAssertEqual(round(temperature.fahrenheit * 10) / 10, expected)
    }
  }
}
