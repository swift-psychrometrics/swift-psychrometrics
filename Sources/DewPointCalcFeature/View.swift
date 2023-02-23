import SwiftUI
import Psychrometrics

public struct DewPointCalcFeature {
  public struct State: Equatable {
    public var solvingFor: SolveFor = .dewPoint
    
    public enum SolveFor: Equatable, CaseIterable, Identifiable {
      case dewPoint
      case relativeHumidity
      case temperature
      
      public var id: Self { self }
      
      public var label: String {
        switch self {
        case .dewPoint: return "Dew Point"
        case .relativeHumidity: return "% RH"
        case .temperature: return "°F"
        }
      }
    }
  }
  
  public enum Action: Equatable {
    case dewPointDidChange
    case relativeHumidityDidChange
    case solvingForDidChange
    case temperatureDidChange
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
        Text("Solve For:")
        
        Picker("Solve For", selection: $solvingFor) {
          ForEach(DewPointCalcFeature.State.SolveFor.allCases) { value in
            Text(value.label)
              .tag(value)
          }
        }
        .padding(.bottom, 50)
        .pickerStyle(.segmented)
        
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
        
//        Text("Dew Point").foregroundColor(.green)
//          .padding(.bottom)
        
      }
      .navigationTitle("Dew Point Calculator")
      .padding()
    }
  }
}

fileprivate let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 3
  return formatter
}()

struct DewPointCalcView_Preview: PreviewProvider {
  
  struct NumberView: View {
    let label: String
    let number: Double
    let units: String
    
    var body: some View {
      HStack {
        Text(label)
          .foregroundColor(.gray)
        Spacer()
        Text(numberFormatter.string(for: number)!)
        Text(units)
      }
      .padding([.leading, .trailing])
    }
  }
  
  struct PsychroView: View {
    
    @State var psychrometrics: PsychrometricResponse? = nil
    
    var body: some View {
      VStack {
        if psychrometrics == nil {
          Text("loading...")
        } else {
          VStack {
            Text("Inputs")
            Divider()
            NumberView(
              label: "Altitude",
              number: 0,
              units: "Ft."
            )
            NumberView(
              label: "Dry Bulb",
              number: 75,
              units: "°F"
            )
            NumberView(
              label: "Humidity",
              number: 50,
              units: "%"
            )
            Divider()
          }
          .padding(.bottom, 50)
          Text("Outputs")
          Divider()
          part1
          NumberView(
            label: "Vapor Pressure",
            number: psychrometrics!.vaporPressure.rawValue.rawValue,
            units: psychrometrics!.vaporPressure.units.symbol
          )
          NumberView(
            label: "Wet Bulb",
            number: psychrometrics!.wetBulb.rawValue.rawValue,
            units: psychrometrics!.wetBulb.rawValue.units.symbol
          )
        }
      }
      .font(.body.bold())
      .onAppear {
        Task {
          psychrometrics = try? await PsychrometricResponse(
            altitude: .seaLevel,
            dryBulb: 75,
            humidity: 50%,
            units: .imperial
          )
        }
      }
    }
    
    var part1: some View {
      Group {
        NumberView(
          label: "Absolute Humidity",
          number: psychrometrics!.grainsOfMoisture.rawValue,
          units: "lb/lb"
        )
        NumberView(
          label: "Atmospheric Pressure",
          number: psychrometrics!.atmosphericPressure.rawValue,
          units: psychrometrics!.atmosphericPressure.units.symbol
        )
        NumberView(
          label: "Degree of Saturation",
          number: psychrometrics!.degreeOfSaturation,
          units: ""
        )
        NumberView(
          label: "Dew Point",
          number: psychrometrics!.dewPoint.rawValue.rawValue,
          units: psychrometrics!.dewPoint.rawValue.units.symbol
        )
        NumberView(
          label: "Density",
          number: psychrometrics!.density.rawValue,
          units: psychrometrics!.density.units.rawValue
        )
        NumberView(
          label: "Enthalpy",
          number: psychrometrics!.enthalpy.rawValue.rawValue,
          units: psychrometrics!.enthalpy.units.rawValue
        )
        NumberView(
          label: "Humidity Ratio",
          number: psychrometrics!.humidityRatio.rawValue.rawValue,
          units: ""
        )
        NumberView(
          label: "Specific Volume",
          number: psychrometrics!.volume.rawValue,
          units: psychrometrics!.volume.units.rawValue
        )
      }
    }
  }
  
  static var previews: some View {
    PsychroView()
//    DewPointCalcView()
  }
}
