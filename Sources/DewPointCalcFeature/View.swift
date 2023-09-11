import ComposableArchitecture
import PsychrometricClient
import SharedModels
import SwiftUI
import Tagged

public struct DewPointCalcFeature: Reducer {
  public struct State: Equatable {

    public var calculateDewPointRequestInFlight: Bool = false
    public var dewPoint: DewPoint? = nil
    @BindingState public var dryBulb: Double = 75
    public var errorDescription: String?
    @BindingState public var relativeHumidity: Double = 50
    @BindingState public var units: PsychrometricUnits = .imperial

    public init(
      dewPoint: DewPoint? = nil,
      dryBulb: Double = 75,
      errorDescription: String? = nil,
      relativeHumidity: Double = 50,
      units: PsychrometricUnits = .imperial
    ) {
      self.dewPoint = dewPoint
      self.dryBulb = dryBulb
      self.errorDescription = errorDescription
      self.relativeHumidity = relativeHumidity
      self.units = units
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case receiveDewPoint(TaskResult<DewPoint>)
    case onTask
  }

  @Dependency(\.psychrometricClient) var client;

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {

      case .binding(\.$relativeHumidity):
        if state.relativeHumidity > 100 {
          state.relativeHumidity = 100
        }
        if state.relativeHumidity < 0 {
          state.relativeHumidity = 0
        }
        prepareToCalculateDewPoint(&state)
        return .run { [state = state] send in
          await send(.receiveDewPoint(calculateDewPoint(state: state)))
        }

      case .binding(\.$units):
        if state.units == .metric {
          state.dryBulb = Temperature(state.dryBulb, units: .fahrenheit).celsius
        } else {
          state.dryBulb = Temperature(state.dryBulb, units: .celsius).fahrenheit
        }
        prepareToCalculateDewPoint(&state)
        return .run { [state = state] send in
          await send(.receiveDewPoint(calculateDewPoint(state: state)))
        }

      case .binding:
        prepareToCalculateDewPoint(&state)
        return .run { [state = state] send in
          await send(.receiveDewPoint(calculateDewPoint(state: state)))
        }

      case let .receiveDewPoint(.failure(error)):
        state.calculateDewPointRequestInFlight = false
        state.errorDescription = String(describing: error)
        return .none

      case let .receiveDewPoint(.success(dewPoint)):
        state.calculateDewPointRequestInFlight = false
        state.dewPoint = dewPoint
        return .none

      case .onTask:
        prepareToCalculateDewPoint(&state)
        return .run { [state = state] send in
          await send(.receiveDewPoint(calculateDewPoint(state: state)))
        }
      }
    }
  }


  func prepareToCalculateDewPoint(_ state: inout State) {
    state.calculateDewPointRequestInFlight = true
    state.errorDescription = nil
  }

  func calculateDewPoint(state: State) async -> TaskResult<DewPoint> {
    await TaskResult {
      try await client.dewPoint(.dryBulb(
        .fahrenheit(state.dryBulb),
        relativeHumidity: state.relativeHumidity%,
        units: state.units
      ))
    }
  }

}

public struct DewPointCalcView: View {
  let store: StoreOf<DewPointCalcFeature>

  public init(store: StoreOf<DewPointCalcFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Form {
        Section("Units") {
          Picker("Units", selection: viewStore.$units) {
            ForEach(PsychrometricUnits.allCases, id: \.self) {
              Text($0.rawValue.capitalized)
                .tag($0)
            }
          }
          .pickerStyle(.segmented)
        }
        Section("Dry Bulb") {
          TextField(
            "Dry Bulb",
            value: viewStore.$dryBulb,
            format: .number.precision(.fractionLength(1))
          )
          #if os(iOS)
            .keyboardType(.decimalPad)
          #endif
          Slider(value: viewStore.$dryBulb, in: 0...200)
        }
        Section("Relative Humidity") {
          TextField(
            "Relative Humidity",
            value: viewStore.$relativeHumidity,
            format: .number.precision(.fractionLength(1))
          )
          #if os(iOS)
            .keyboardType(.decimalPad)
          #endif
          Slider(value: viewStore.$relativeHumidity, in: 0...100)
        }
        Section {
          if let dewPoint = viewStore.dewPoint {
            Text(dewPoint.fahrenheit, format: .number.precision(.fractionLength(1)))
          }
        } header: {
          HStack {
            Text("Dew Point")
            if viewStore.calculateDewPointRequestInFlight {
              Spacer()
              ProgressView()
            }
          }
        }
        Section {
          if let error = viewStore.errorDescription {
            Text(error)
              .foregroundStyle(Color.red)
              .font(.callout)
          }
        }
      }
      .task { await viewStore.send(.onTask).finish() }
    }
  }
}

fileprivate let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 3
  return formatter
}()

#if DEBUG
import PsychrometricClientLive

struct TestError: Error, CustomDebugStringConvertible {

  var debugDescription: String { localizedDescription }

  var localizedDescription: String {
    "This is a test error description."
  }
}

struct DewPointCalcView_Preview: PreviewProvider {

  static var previews: some View {
    DewPointCalcView(
      store: .init(initialState: .init()) {
        DewPointCalcFeature()
      } withDependencies: {
        $0.psychrometricClient.override(
          \.dewPoint,
           closure: PsychrometricClient.liveValue.dewPoint
        )
        $0.psychrometricClient.override(
          \.vaporPressure,
           closure: PsychrometricClient.liveValue.vaporPressure
        )
      }
    )
    .previewDisplayName("Live View")

    DewPointCalcView(
      store: .init(initialState: .init()) {
        DewPointCalcFeature()
      } withDependencies: {
        $0.psychrometricClient.override(\.dewPoint) { _ in
          throw TestError()
        }
      }
    )
    .previewDisplayName("Error View")
  }
}
#endif
