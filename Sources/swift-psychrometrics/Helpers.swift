import Foundation

let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 3
  return formatter
}()

func numberString(for value: Double) -> String {
  numberFormatter.string(for: value) ?? "\(value)"
}
