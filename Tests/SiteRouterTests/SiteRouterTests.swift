import XCTest
import CustomDump
import Dependencies
import SharedModels
import SiteRouter
import URLRouting

final class SiteRouterTests: XCTestCase {
  
  override func invokeTest() {
    withDependencies {
      $0.siteRouter = SiteRouterKey.liveValue
    } operation: {
      super.invokeTest()
    }
  }
  
  func test_density_dryAir_altitude() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "altitude" : 0,
        "dryBulb" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dryAir/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dryAir(.density(.altitude(.init(altitude: .zero, dryBulb: .zero))))
    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }
  
  func test_density_dryAir_totalPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "totalPressure" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dryAir/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dryAir(.density(.totalPressure(
      .init(dryBulb: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_density_moistAir_humidityRatio() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "humidityRatio" : 0,
        "totalPressure" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.density(.humidityRatio(
      .init(
        dryBulb: .zero,
        humidityRatio: .zero,
        totalPressure: .zero
      )
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_density_moistAir_relativeHumidity() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "humidity" : 0,
        "totalPressure" : 0,
        "units": "imperial"
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.density(.relativeHumidity(
      .init(
        dryBulb: .zero,
        humidity: .zero,
        totalPressure: .zero,
        units: .imperial
      )
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_density_moistAir_specificVolume() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "humidityRatio": 0,
        "specificVolume" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.density(.specificVolume(
      .init(humidityRatio: .zero, specificVolume: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_density_water() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/water/density")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.water(.density(.init(dryBulb: .zero)))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_dewPoint_temperature() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "humidity" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/dewPoint")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.dewPoint(.temperature(
      .init(dryBulb: .zero, humidity: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_dewPoint_vaporPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "vaporPressure" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/dewPoint")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.dewPoint(.vaporPressure(
      .init(dryBulb: .zero, vaporPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_dewPoint_wetBulb() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "totalPressure" : 0,
        "wetBulb" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/dewPoint")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.dewPoint(.wetBulb(
      .init(dryBulb: .zero, totalPressure: .zero, wetBulb: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_enthalpy_dryAir() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "units" : "metric"
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dryAir/enthalpy")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dryAir(.enthalpy(
      .init(dryBulb: .zero, units: .metric)
    ))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_enthalpy_moistAir_altitude() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "altitude" : 0,
        "humidity" : 0,
        "dryBulb" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/enthalpy")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.enthalpy(.altitude(
      .init(
        altitude: .seaLevel,
        dryBulb: .zero,
        humidity: 0%
      )
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_enthalpy_moistAir_pressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/enthalpy")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.enthalpy(.totalPressure(
      .init(
        dryBulb: .zero,
        humidity: 0%,
        totalPressure: .zero
      )
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_grainsOfMoisture_altitude() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "altitude": 0,
        "dryBulb": 0,
        "humidity": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/grainsOfMoisture")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.altitude(
      .init(
        altitude: .zero,
        dryBulb: .zero,
        humidity: 0%
      )
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_grainsOfMoisture_temperature() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb" : 0,
        "humidity" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/grainsOfMoisture")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.temperature(
      .init(dryBulb: .zero, humidity: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_grainsOfMoisture_pressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/grainsOfMoisture")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.grainsOfMoisture(.totalPressure(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
    )))
    print(route)

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_humidityRatio_dewPoint() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dewPoint": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.humidityRatio(.dewPoint(
      .init(dewPoint: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_humidityRatio_enthalpy() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "enthalpy": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.humidityRatio(.enthalpy(
      .init(dryBulb: .zero, enthalpy: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_humidityRatio_saturationPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "totalPressure": 0,
        "saturationPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.humidityRatio(.pressure(.saturation(
      .init(totalPressure: .zero, saturationPressure: .zero)
    ))))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_humidityRatio_vaporPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "totalPressure": 0,
        "vaporPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.humidityRatio(.pressure(.vapor(
      .init(totalPressure: .zero, vaporPressure: .zero)
    ))))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_humidityRatio_specificHumidity() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "specificHumidity": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.humidityRatio(.specificHumidity(
      .init(specificHumidity: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }
  
  func test_psychrometrics_altitude() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
    {
      "altitude": 0,
      "dryBulb": 0,
      "humidity": 0
    }
    """
    
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/psychrometrics")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.psychrometrics(.altitude(
      .init(altitude: .zero, dryBulb: .zero, humidity: 0%)
    )))
    
    XCTAssertNoDifference(
      route,
      .api(.init(isDebug: false, route: expectedRoute))
    )
  }

  func test_psychrometrics_dewPoint() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dewPoint": 0,
        "dryBulb": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/psychrometrics")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.psychrometrics(.dewPoint(
      .init(dewPoint: .zero, dryBulb: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_psychrometrics_relativeHumidity() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/psychrometrics")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.psychrometrics(.relativeHumidity(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_psychrometrics_wetBulb() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "totalPressure": 0,
        "wetBulb": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/psychrometrics")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.psychrometrics(.wetBulb(
      .init(dryBulb: .zero, totalPressure: .zero, wetBulb: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_relativeHumidity_humidityRatio() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidityRatio": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.relativeHumidity(.humidityRatio(
      .init(dryBulb: .zero, humidityRatio: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_relativeHumidity_vaporPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "vaporPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.relativeHumidity(.vaporPressure(
      .init(dryBulb: .zero, vaporPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_specificHeat_water() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/water/specificHeat")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.water(.specificHeat(
      .init(dryBulb: .zero)
    ))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_specificVolume_dryAir() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dryAir/specificVolume")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dryAir(.specificVolume(
      .init(dryBulb: .zero, totalPressure: .zero)
    ))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_specificVolume_moistAir_altitude() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "altitude": 0,
        "dryBulb": 0,
        "humidity": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/specificVolume")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.specificVolume(.altitude(
      .init(altitude: .seaLevel, dryBulb: .zero, humidity: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_specificVolume_moistAir_humidityRatio() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidityRatio": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/specificVolume")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.specificVolume(.humidityRatio(
      .init(dryBulb: .zero, humidityRatio: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_specificVolume_moistAir_relativeHumidity() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/specificVolume")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.specificVolume(.relativeHumidity(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }
  
  func test_vaporPressure_humidityRatio() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "humidityRatio": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/vaporPressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.vaporPressure(.humidityRatio(
      .init(humidityRatio: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }

  func test_wetBulb_relativeHumidity() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/moistAir/wetBulb")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.moistAir(.wetBulb(.relativeHumidity(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
    )))

    XCTAssertNoDifference(
      route,
      .api(
        .init(
          isDebug: false,
          route: expectedRoute
        )
      )
    )
  }
}

