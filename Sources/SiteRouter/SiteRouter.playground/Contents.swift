import Foundation
import SharedModels
import SiteRouter
import URLRouting

var greeting = "Hello, playground"

let json = """
{
  "dryBulb": 0,
  "totalPressure": 0
}
"""
var request = URLRequest(url: URL(string: "/density")!)
request.httpMethod = "POST"
request.httpBody = Data(json.utf8)

let res = try route2DensityRouter.match(request: request)

print(res)
