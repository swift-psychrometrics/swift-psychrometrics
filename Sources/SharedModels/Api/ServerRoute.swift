import Tagged

/// Represents the server routes.
///
public enum ServerRoute: Codable, Equatable, Sendable {
  
  case api(Api)
  
  public struct Api: Codable, Equatable, Sendable {
    
    public var isDebug: Bool
    public var route: Route
    
    public init(isDebug: Bool, route: Route) {
      self.isDebug = isDebug
      self.route = route
    }
    
    // MARK: API Routes
    public enum Route: Codable, Equatable, Sendable {
      
      case dewPoint(DewPoint)
      case enthalpy(Enthalpy)
      case humidityRatio(HumidityRatio)
      case relativeHumidity(RelativeHumidity)
      case vaporPressure(VaporPressure)
      
      // MARK: - Dew Point
      public enum DewPoint: Codable, Equatable, Sendable {
        case temperature(Temperature)
        case vaporPressure(VaporPressure)
        
        public struct Temperature: Codable, Equatable, Sendable {
          public var temperature: DryBulb
          public var humidity: RelativeHumidity
          
          public init(
            temperature: DryBulb,
            humidity: RelativeHumidity
          ) {
            self.temperature = temperature
            self.humidity = humidity
          }
        }
        
        public struct VaporPressure: Codable, Equatable, Sendable {
          public var vaporPressure: SharedModels.VaporPressure
          public var temperature: DryBulb
          
          public init(
            vaporPressure: SharedModels.VaporPressure,
            temperature: DryBulb
          ) {
            self.vaporPressure = vaporPressure
            self.temperature = temperature
          }
        }
      }
      
      // MARK: - Enthalpy
      public enum Enthalpy: Codable, Equatable, Sendable {
        case dryAir(DryAir)
        case moistAir(MoistAir)
        
        public struct DryAir: Codable, Equatable, Sendable {
          
          public var temperature: DryBulb
          public var units: PsychrometricUnits?
          
          public init(temperature: DryBulb, units: PsychrometricUnits? = nil) {
            self.temperature = temperature
            self.units = units
          }
        }
        
        public enum MoistAir: Codable, Equatable, Sendable {
          case altitude(Altitude)
          case pressure(Pressure)
          
          public struct Altitude: Codable, Equatable, Sendable {
            
            public var altitude: Length
            public var humidity: RelativeHumidity
            public var temperature: DryBulb
            public var units: PsychrometricUnits?
            
            public init(
              altitude: Length = .seaLevel,
              humidity: RelativeHumidity,
              temperature: DryBulb,
              units: PsychrometricUnits? = nil
            ) {
              self.altitude = altitude
              self.temperature = temperature
              self.humidity = humidity
              self.units = units
            }
          }
          
          public struct Pressure: Codable, Equatable, Sendable {
            public var humidity: RelativeHumidity
            public var temperature: DryBulb
            public var totalPressure: TotalPressure
            public var units: PsychrometricUnits?
            
            public init(
              humidity: RelativeHumidity,
              temperature: DryBulb,
              totalPressure: TotalPressure,
              units: PsychrometricUnits? = nil
            ) {
              self.humidity = humidity
              self.temperature = temperature
              self.totalPressure = totalPressure
              self.units = units
            }
          }
        }
      }
      
      // MARK: - Grains of Moisture
      public enum GrainsOfMoisture: Codable, Equatable, Sendable {
        
        case altitude(Altitude)
        case temperature(Temperature)
        case pressure(Pressure)
        
        public struct Altitude: Codable, Equatable, Sendable {
          public var altitude: Length
          public var humidity: RelativeHumidity
          public var temperature: DryBulb
          
          public init(
            altitude: Length = .seaLevel,
            humidity: RelativeHumidity,
            temperature: DryBulb
          ) {
            self.altitude = altitude
            self.humidity = humidity
            self.temperature = temperature
          }
        }
        
        public struct Temperature: Codable, Equatable, Sendable {
          
          public var temperature: DryBulb
          public var humidity: RelativeHumidity
          
          public init(
            temperature: DryBulb,
            humidity: RelativeHumidity
          ) {
            self.temperature = temperature
            self.humidity = humidity
          }
        }
        
        public struct Pressure: Codable, Equatable, Sendable {
          public var temperature: SharedModels.Temperature
          public var humidity: RelativeHumidity
          public var pressure: SharedModels.Pressure
          
          public init(
            temperature: SharedModels.Temperature,
            humidity: RelativeHumidity,
            pressure: SharedModels.Pressure
          ) {
            self.temperature = temperature
            self.humidity = humidity
            self.pressure = pressure
          }
        }
      }
      
      // MARK: - Humidity Ratio
      public enum HumidityRatio: Codable, Equatable, Sendable {
        
        case dewPoint(DewPoint)
        case enthalpy(Enthalpy)
        case pressure(Pressure)
        case specificHumidity(SpecificHumidity)
        case wetBulb(WetBulb)
        
        public struct DewPoint: Codable, Equatable, Sendable {
          public var dewPoint: SharedModels.DewPoint
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?
          
          public init(
            dewPoint: SharedModels.DewPoint,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dewPoint = dewPoint
            self.totalPressure = totalPressure
          }
          
        }
        
        public struct Enthalpy: Codable, Equatable, Sendable {
          public var enthalpy: MoistAirEnthalpy
          public var dryBulb: DryBulb
        }
        
        public enum Pressure: Codable, Equatable, Sendable {
          
          case saturation(Saturation)
          case vapor(Vapor)
          
          public struct Saturation: Codable, Equatable, Sendable {
            public var total: TotalPressure
            public var saturation: SaturationPressure
            
            public init(
              total: TotalPressure,
              saturation: SaturationPressure
            ) {
              self.total = total
              self.saturation = saturation
            }
          }
          
          public struct Vapor: Codable, Equatable, Sendable {
            public var totalPressure: TotalPressure
            public var vaporPressure: VaporPressure
            
            public init(
              totalPressure: TotalPressure,
              vaporPressure: VaporPressure
            ) {
              self.totalPressure = totalPressure
              self.vaporPressure = vaporPressure
            }
          }
          
          public struct WetBulb: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb
            public var totalPressure: TotalPressure
            public var wetBulb: SharedModels.WetBulb
            public var units: PsychrometricUnits?
            
            public init(
              dryBulb: DryBulb,
              totalPressure: TotalPressure,
              wetBulb: SharedModels.WetBulb,
              units: PsychrometricUnits? = nil
            ) {
              self.dryBulb = dryBulb
              self.totalPressure = totalPressure
              self.wetBulb = wetBulb
              self.units = units
            }
          }
          
        }
      }
      
      // MARK: - Relative Humidity
      public enum RelativeHumidity: Codable, Equatable, Sendable {
        
        case humidityRatio(HumidityRatio)
        case vaporPressure(VaporPressure)
        
        public struct HumidityRatio: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var humidityRatio: SharedModels.HumidityRatio
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?
          
          public init(
            dryBulb: DryBulb,
            humidityRatio: SharedModels.HumidityRatio,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dryBulb = dryBulb
            self.humidityRatio = humidityRatio
            self.totalPressure = totalPressure
            self.units = units
          }
        }
        
        public struct VaporPressure: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var vaporPressure: SharedModels.VaporPressure
          public var units: PsychrometricUnits?
          
          public init(
            dryBulb: DryBulb,
            vaporPressure: SharedModels.VaporPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dryBulb = dryBulb
            self.vaporPressure = vaporPressure
            self.units = units
          }
        }
      }
      
      // MARK: - Vapor Pressure
      public enum VaporPressure: Codable, Equatable, Sendable {
        case humidityRatio(HumidityRatio)
        
        public struct HumidityRatio: Codable, Equatable, Sendable {
          public var humidityRatio: SharedModels.HumidityRatio
          public var pressure: TotalPressure
          public var unit: PsychrometricUnits?
          
          public init(
            humidityRatio: SharedModels.HumidityRatio,
            pressure: TotalPressure,
            unit: PsychrometricUnits? = nil
          ) {
            self.humidityRatio = humidityRatio
            self.pressure = pressure
            self.unit = unit
          }
        }
      }
      
      // MARK: -
    }
  }
}

// MARK: - Codable
