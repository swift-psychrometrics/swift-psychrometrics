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
    var request = URLRequest(url: URL(string: "/api/v1/density/dryAir/altitude")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.density(.dryAir(.altitude(
      .init(
        altitude: .seaLevel,
        dryBulb: .zero
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
  
  func test_density_dryAir_totalPressure() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "totalPressure" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/density/dryAir/totalPressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.density(.dryAir(.totalPressure(
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
    var request = URLRequest(url: URL(string: "/api/v1/density/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.density(.moistAir(.humidityRatio(
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
    var request = URLRequest(url: URL(string: "/api/v1/density/moistAir/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.density(.moistAir(.relativeHumidity(
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
    var request = URLRequest(url: URL(string: "/api/v1/density/moistAir/specificVolume")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.density(.moistAir(.specificVolume(
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
  
  func test_dewPoint_temperature() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "humidity" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dewPoint/temperature")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dewPoint(.temperature(
      .init(dryBulb: .zero, humidity: .zero)
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
  
  func test_dewPoint_vaporPressure() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "vaporPressure" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dewPoint/vaporPressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dewPoint(.vaporPressure(
      .init(dryBulb: .zero, vaporPressure: .zero)
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
  
  func test_dewPoint_wetBulb() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "totalPressure" : 0,
        "wetBulb" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/dewPoint/wetBulb")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.dewPoint(.wetBulb(
      .init(dryBulb: .zero, totalPressure: .zero, wetBulb: .zero)
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
  
  func test_enthalpy_dryAir() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "units" : "metric"
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/enthalpy/dryAir")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.enthalpy(.dryAir(
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
    var request = URLRequest(url: URL(string: "/api/v1/enthalpy/moistAir/altitude")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.enthalpy(.moistAir(.altitude(
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
    var request = URLRequest(url: URL(string: "/api/v1/enthalpy/moistAir/pressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.enthalpy(.moistAir(.pressure(
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
    var request = URLRequest(url: URL(string: "/api/v1/grainsOfMoisture/altitude")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.grainsOfMoisture(.altitude(
      .init(
        altitude: .zero,
        dryBulb: .zero,
        humidity: 0%
      )
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
  
  func test_grainsOfMoisture_temperature() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb" : 0,
        "humidity" : 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/grainsOfMoisture/temperature")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.grainsOfMoisture(.temperature(
      .init(dryBulb: .zero, humidity: .zero)
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
  
  func test_grainsOfMoisture_pressure() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/grainsOfMoisture/totalPressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.grainsOfMoisture(.totalPressure(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
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
  
  func test_humidityRatio_dewPoint() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dewPoint": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/humidityRatio/dewPoint")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.humidityRatio(.dewPoint(
      .init(dewPoint: .zero, totalPressure: .zero)
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
  
  func test_humidityRatio_enthalpy() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "enthalpy": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/humidityRatio/enthalpy")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.humidityRatio(.enthalpy(
      .init(dryBulb: .zero, enthalpy: .zero)
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
  
  func test_humidityRatio_saturationPressure() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "totalPressure": 0,
        "saturationPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/humidityRatio/pressure/saturation")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.humidityRatio(.pressure(.saturation(
      .init(totalPressure: .zero, saturationPressure: .zero)
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
  
  func test_humidityRatio_vaporPressure() throws {

    @Dependency(\.siteRouter) var router

    let json = """
      {
        "totalPressure": 0,
        "vaporPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/humidityRatio/pressure/vapor")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)

    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.humidityRatio(.pressure(.vapor(
      .init(totalPressure: .zero, vaporPressure: .zero)
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
  
  func test_humidityRatio_specificHumidity() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "specificHumidity": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/humidityRatio/specificHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.humidityRatio(.specificHumidity(
      .init(specificHumidity: .zero)
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
  
  func test_psychrometrics_dewPoint() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dewPoint": 0,
        "dryBulb": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/psychrometrics/dewPoint")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.psychrometrics(.dewPoint(
      .init(dewPoint: .zero, dryBulb: .zero, totalPressure: .zero)
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
  
  func test_psychrometrics_relativeHumidity() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/psychrometrics/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.psychrometrics(.relativeHumidity(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
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
  
  func test_psychrometrics_wetBulb() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "totalPressure": 0,
        "wetBulb": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/psychrometrics/wetBulb")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.psychrometrics(.wetBulb(
      .init(dryBulb: .zero, totalPressure: .zero, wetBulb: .zero)
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
  
  func test_relativeHumidity_humidityRatio() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "humidityRatio": 0,
        "totalPressure": 0
      }
    """
    var request = URLRequest(url: URL(string: "/api/v1/relativeHumidity/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.relativeHumidity(.humidityRatio(
      .init(dryBulb: .zero, humidityRatio: .zero, totalPressure: .zero)
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
  
  func test_relativeHumidity_vaporPressure() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "vaporPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/relativeHumidity/vaporPressure")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.relativeHumidity(.vaporPressure(
      .init(dryBulb: .zero, vaporPressure: .zero)
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
  
  func test_specificHeat_water() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/specificHeat/water")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.specificHeat(.water(
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
    var request = URLRequest(url: URL(string: "/api/v1/specificVolume/dryAir")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.specificVolume(.dryAir(
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
    var request = URLRequest(url: URL(string: "/api/v1/specificVolume/moistAir/altitude")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.specificVolume(.moistAir(.altitude(
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
    var request = URLRequest(url: URL(string: "/api/v1/specificVolume/moistAir/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.specificVolume(.moistAir(.humidityRatio(
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
    var request = URLRequest(url: URL(string: "/api/v1/specificVolume/moistAir/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.specificVolume(.moistAir(.relativeHumidity(
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
    var request = URLRequest(url: URL(string: "/api/v1/vaporPressure/humidityRatio")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.vaporPressure(.humidityRatio(
      .init(humidityRatio: .zero, totalPressure: .zero)
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
  
  func test_wetBulb_relativeHumidity() throws {
    
    @Dependency(\.siteRouter) var router
    
    let json = """
      {
        "dryBulb": 0,
        "humidity": 0,
        "totalPressure": 0
    }
    """
    var request = URLRequest(url: URL(string: "/api/v1/wetBulb/relativeHumidity")!)
    request.httpMethod = "POST"
    request.httpBody = Data(json.utf8)
    
    let route = try router.match(request: request)
    let expectedRoute = ServerRoute.Api.Route.wetBulb(.relativeHumidity(
      .init(dryBulb: .zero, humidity: .zero, totalPressure: .zero)
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
}

