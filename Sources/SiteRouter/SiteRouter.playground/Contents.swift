import Foundation
import SharedModels
import SiteRouter

var greeting = "Hello, playground"

let encoder: JSONEncoder = {
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
  return encoder
}()

let data = ServerRoute.Api.Route.Density.DryAir.Altitude(
  altitude: .seaLevel,
  dryBulb: .zero
)

let string = String(data: try! encoder.encode(data), encoding: .utf8)

print(string!)
