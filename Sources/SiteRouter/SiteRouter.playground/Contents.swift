import Foundation
import SharedModels
import SiteRouter
import URLRouting

var greeting = "Hello, playground"

let encoder: JSONEncoder = {
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
  return encoder
}()

let data = ServerRoute.Api.Route.Density.DryAir.Pressure(dryBulb: .zero, totalPressure: .zero)
let string = String(data: try! encoder.encode(data), encoding: .utf8)
print(string!)

