import Foundation
import SharedModels
@testable import SiteRouter
import URLRouting

var greeting = "Hello, playground"

let json = """
{
  "dryBulb": 0,
  "humidity": 0,
  "altitude": 0
}
"""
var request = URLRequest(url: URL(string: "/moistAir/enthalpy")!)
request.httpMethod = "POST"
request.httpBody = Data(json.utf8)

let router: AnyParserPrinter<URLRequestData, ServerRoute.Api.Route> = apiRouter(
  decoder: .init(),
  encoder: .init()
)

let res = try router.match(request: request)
print(res)
