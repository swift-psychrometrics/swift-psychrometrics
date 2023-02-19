import XCTest
import CustomDump
import Dependencies
import SiteRouter

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
    
    XCTAssertNoDifference(
      route,
      .api(.init(
          isDebug: false,
          route: .density(
            .dryAir(.altitude(.init(
                  altitude: .seaLevel,
                  dryBulb: 0
                )))
          )
        ))
    )
  }
}

