import SwiftUI

public struct DewPointCalcFeature {
  public struct State: Equatable {
    public var solvingFor: SolveFor = .dewPoint
    
    public enum SolveFor: Equatable {
      case temperature
      case relativeHumidity
      case dewPoint
    }
  }
  
  public enum Action: Equatable {
    case temperatureChanged
    case relativeHumidityChanged
    case dewPointChanged
  }
}

public struct DewPointCalcView: View {
  
  @State var temperature: Double = 75.0
  @State var relativeHumidity: Double = 50
  @State var dewPoint: Double = 55
  @State var solvingFor: DewPointCalcFeature.State.SolveFor = .dewPoint
  
  public var body: some View {
    NavigationView {
      VStack {
        Text("\(numberFormatter.string(for: temperature) ?? "0")").foregroundColor(.red)
        Slider(
          value: $temperature,
          in: -4...150,
          step: 1
        ) {
          Text("Temperature")
        }
        .tint(.red)
        .disabled(solvingFor == .temperature)
        Text("Temperature").foregroundColor(.red)
          .padding(.bottom)
        
        Text("\(numberFormatter.string(for: relativeHumidity) ?? "0")").foregroundColor(.blue)
        Slider(
          value: $relativeHumidity,
          in: 0...100,
          step: 1
        ) {
          Text("Relative Humidity")
        }
        .tint(.blue)
        .disabled(solvingFor == .relativeHumidity)
        Text("Relative Humidity").foregroundColor(.blue)
          .padding(.bottom)
        
        Text("\(numberFormatter.string(for: dewPoint) ?? "0")").foregroundColor(.green)
        Slider(
          value: $dewPoint,
          in: -85...150,
          step: 1
        ) {
          Text("Dew Point")
        }
        .tint(.green)
        .disabled(solvingFor == .dewPoint)
        Text("Dew Point").foregroundColor(.green)
          .padding(.bottom)
        
      }
      .navigationTitle("Dew Point Calculator")
      .padding()
    }
  }
}

fileprivate let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.maximumFractionDigits = 0
  return formatter
}()

struct DewPointCalcView_Preview: PreviewProvider {
  static var previews: some View {
    DewPointCalcView()
  }
}
