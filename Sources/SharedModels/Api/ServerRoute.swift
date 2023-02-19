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

      case density(Density)
      case dewPoint(DewPoint)
      case enthalpy(Enthalpy)
      case grainsOfMoisture(GrainsOfMoisture)
      case humidityRatio(HumidityRatio)
      case psychrometrics(Psychrometrics)
      case relativeHumidity(RelativeHumidity)
      case specificHeat(SpecificHeat)
      case specificVolume(SpecificVolume)
      case vaporPressure(VaporPressure)
      case wetBulb(WetBulb)
      
      public enum Key: String, RouteKey {
        case density
        case dewPoint
        case enthalpy
        case grainsOfMoisture
        case humidityRatio
        case psychrometrics
        case relativeHumidity
        case specificHeat
        case specificVolume
        case vaporPressure
        case wetBulb
      }

      // MARK: - Density
      public enum Density: Codable, Equatable, Sendable {
        case dryAir(DryAir)
        case moistAir(MoistAir)
        case water(Temperature)
        
        public enum Key: String, RouteKey {
          case dryAir
          case moistAir
          case water
        }

        public enum DryAir: Codable, Equatable, Sendable {

          case altitude(Altitude)
          case totalPressure(Pressure)
          
          public enum Key: String, RouteKey {
            case altitude
            case totalPressure
          }

          public struct Altitude: Codable, Equatable, Sendable {
            public var altitude: Length
            public var dryBulb: DryBulb
            public var units: PsychrometricUnits?

            public init(
              altitude: Length,
              dryBulb: DryBulb,
              units: PsychrometricUnits? = nil
            ) {
              self.altitude = altitude
              self.dryBulb = dryBulb
              self.units = units
            }
          }

          public struct Pressure: Codable, Equatable, Sendable {

            public var dryBulb: DryBulb
            public var totalPressure: TotalPressure
            public var units: PsychrometricUnits?

            public init(
              dryBulb: DryBulb,
              totalPressure: TotalPressure,
              units: PsychrometricUnits? = nil
            ) {
              self.dryBulb = dryBulb
              self.totalPressure = totalPressure
              self.units = units
            }
          }
        }

        public enum MoistAir: Codable, Equatable, Sendable {
          case humidityRatio(HumidityRatio)
          case relativeHumidity(RelativeHumidity)
          case specificVolume(SpecificVolume)
          
          public enum Key: String, RouteKey {
            case humidityRatio
            case relativeHumidity
            case specificVolume
          }

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

          public struct RelativeHumidity: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb
            public var humidity: SharedModels.RelativeHumidity
            public var totalPressure: TotalPressure
            public var units: PsychrometricUnits?

            public init(
              dryBulb: DryBulb,
              humidity: SharedModels.RelativeHumidity,
              totalPressure: TotalPressure,
              units: PsychrometricUnits? = nil
            ) {
              self.dryBulb = dryBulb
              self.humidity = humidity
              self.totalPressure = totalPressure
              self.units = units
            }
          }

          public struct SpecificVolume: Codable, Equatable, Sendable {
            public var humidityRatio: SharedModels.HumidityRatio
            public var specificVolume: SpecificVolumeOf<SharedModels.MoistAir>
            public var units: PsychrometricUnits?

            public init(
              humidityRatio: SharedModels.HumidityRatio,
              specificVolume: SpecificVolumeOf<SharedModels.MoistAir>,
              units: PsychrometricUnits? = nil
            ) {
              self.humidityRatio = humidityRatio
              self.specificVolume = specificVolume
              self.units = units
            }
          }
        }
      }

      // MARK: - Dew Point
      public enum DewPoint: Codable, Equatable, Sendable {
        case temperature(Temperature)
        case vaporPressure(VaporPressure)
        case wetBulb(WetBulb)
        
        public enum Key: String, RouteKey {
          case temperature
          case vaporPressure
          case wetBulb
        }

        public struct Temperature: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var humidity: SharedModels.RelativeHumidity

          public init(
            dryBulb: DryBulb,
            humidity: SharedModels.RelativeHumidity
          ) {
            self.dryBulb = dryBulb
            self.humidity = humidity
          }
        }

        public struct VaporPressure: Codable, Equatable, Sendable {
          public var vaporPressure: SharedModels.VaporPressure
          public var dryBulb: DryBulb

          public init(
            dryBulb: DryBulb,
            vaporPressure: SharedModels.VaporPressure
          ) {
            self.vaporPressure = vaporPressure
            self.dryBulb = dryBulb
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

      // MARK: - Enthalpy
      public enum Enthalpy: Codable, Equatable, Sendable {
        case dryAir(DryAir)
        case moistAir(MoistAir)
        
        public enum Key: String, RouteKey {
          case dryAir
          case moistAir
        }

        public struct DryAir: Codable, Equatable, Sendable {

          public var dryBulb: DryBulb
          public var units: PsychrometricUnits?

          public init(dryBulb: DryBulb, units: PsychrometricUnits? = nil) {
            self.dryBulb = dryBulb
            self.units = units
          }
        }

        public enum MoistAir: Codable, Equatable, Sendable {
          case altitude(Altitude)
          case pressure(Pressure)
          
          public enum Key: String, RouteKey {
            case altitude
            case pressure
          }

          public struct Altitude: Codable, Equatable, Sendable {

            public var altitude: Length
            public var dryBulb: DryBulb
            public var humidity: SharedModels.RelativeHumidity
            public var units: PsychrometricUnits?

            public init(
              altitude: Length = .seaLevel,
              dryBulb: DryBulb,
              humidity: SharedModels.RelativeHumidity,
              units: PsychrometricUnits? = nil
            ) {
              self.altitude = altitude
              self.dryBulb = dryBulb
              self.humidity = humidity
              self.units = units
            }
          }

          public struct Pressure: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb
            public var humidity: SharedModels.RelativeHumidity
            public var totalPressure: TotalPressure
            public var units: PsychrometricUnits?

            public init(
              dryBulb: DryBulb,
              humidity: SharedModels.RelativeHumidity,
              totalPressure: TotalPressure,
              units: PsychrometricUnits? = nil
            ) {
              self.dryBulb = dryBulb
              self.humidity = humidity
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
        case totalPressure(Pressure)
        
        public enum Key: String, RouteKey {
          case altitude
          case temperature
          case totalPressure
        }

        public struct Altitude: Codable, Equatable, Sendable {
          public var altitude: Length
          public var dryBulb: DryBulb
          public var humidity: SharedModels.RelativeHumidity

          public init(
            altitude: Length = .seaLevel,
            dryBulb: DryBulb,
            humidity: SharedModels.RelativeHumidity
          ) {
            self.altitude = altitude
            self.dryBulb = dryBulb
            self.humidity = humidity
          }
        }

        public struct Temperature: Codable, Equatable, Sendable {

          public var dryBulb: DryBulb
          public var humidity: SharedModels.RelativeHumidity

          public init(
            dryBulb: DryBulb,
            humidity: SharedModels.RelativeHumidity
          ) {
            self.dryBulb = dryBulb
            self.humidity = humidity
          }
        }

        public struct Pressure: Codable, Equatable, Sendable {
          public var dryBulb: SharedModels.Temperature
          public var humidity: SharedModels.RelativeHumidity
          public var totalPressure: SharedModels.TotalPressure

          public init(
            dryBulb: SharedModels.Temperature,
            humidity: SharedModels.RelativeHumidity,
            totalPressure: SharedModels.TotalPressure
          ) {
            self.dryBulb = dryBulb
            self.humidity = humidity
            self.totalPressure = totalPressure
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
        
        public enum Key: String, RouteKey {
          case dewPoint
          case enthalpy
          case pressure
          case specificHumidity
          case wetBulb
        }

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
          
          public init(
            dryBulb: DryBulb,
            enthalpy: MoistAirEnthalpy
          ) {
            self.enthalpy = enthalpy
            self.dryBulb = dryBulb
          }
        }

        public enum Pressure: Codable, Equatable, Sendable {
          
          case saturation(Saturation)
          case vapor(Vapor)
          
          public enum Key: String, RouteKey {
            case saturation
            case vapor
          }
          
          public struct Saturation: Codable, Equatable, Sendable {
            public var totalPressure: TotalPressure
            public var saturationPressure: SaturationPressure
            
            public init(
              totalPressure: TotalPressure,
              saturationPressure: SaturationPressure
            ) {
              self.totalPressure = totalPressure
              self.saturationPressure = saturationPressure
            }
          }
          
          public struct Vapor: Codable, Equatable, Sendable {
            public var totalPressure: TotalPressure
            public var vaporPressure: SharedModels.VaporPressure
            
            public init(
              totalPressure: TotalPressure,
              vaporPressure: SharedModels.VaporPressure
            ) {
              self.totalPressure = totalPressure
              self.vaporPressure = vaporPressure
            }
          }
        }
        
        public struct SpecificHumidity: Codable, Equatable, Sendable {
          public var specificHumidity: SharedModels.SpecificHumidity
          
          public init(specificHumidity: SharedModels.SpecificHumidity) {
            self.specificHumidity = specificHumidity
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

      // MARK: - Psychrometrics
      // TODO: Add altitude.
      public enum Psychrometrics: Codable, Equatable, Sendable {
        case dewPoint(DewPoint)
        case relativeHumidity(RelativeHumidity)
        case wetBulb(WetBulb)
        
        public enum Key: String, RouteKey {
          case dewPoint
          case relativeHumidity
          case wetBulb
        }

        public struct DewPoint: Codable, Equatable, Sendable {
          public var dewPoint: SharedModels.DewPoint
          public var dryBulb: DryBulb
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?

          public init(
            dewPoint: SharedModels.DewPoint,
            dryBulb: DryBulb,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dewPoint = dewPoint
            self.dryBulb = dryBulb
            self.totalPressure = totalPressure
            self.units = units
          }
        }

        public struct RelativeHumidity: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var humidity: SharedModels.RelativeHumidity
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?

          public init(
            dryBulb: DryBulb,
            humidity: SharedModels.RelativeHumidity,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dryBulb = dryBulb
            self.humidity = humidity
            self.totalPressure = totalPressure
            self.units = units
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

      // MARK: - Relative Humidity
      public enum RelativeHumidity: Codable, Equatable, Sendable {

        case humidityRatio(HumidityRatio)
        case vaporPressure(VaporPressure)
        
        public enum Key: String, RouteKey {
          case humidityRatio
          case vaporPressure
        }

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

      // MARK: - Specific Heat
      public enum SpecificHeat: Codable, Equatable, Sendable {
        case water(Water)
        
        public enum Key: String, RouteKey {
          case water
        }
        
        public struct Water: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          
          public init(dryBulb: DryBulb) {
            self.dryBulb = dryBulb
          }
        }
      }

      // MARK: - Specific Volume
      public enum SpecificVolume: Codable, Equatable, Sendable {
        case dryAir(DryAir)
        case moistAir(MoistAir)
        
        public enum Key: String, RouteKey {
          case dryAir
          case moistAir
        }
        
        public struct DryAir: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?

          public init(
            dryBulb: DryBulb,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dryBulb = dryBulb
            self.totalPressure = totalPressure
            self.units = units
          }
        }

        public enum MoistAir: Codable, Equatable, Sendable {
          case altitude(Altitude)
          case humidityRatio(HumidityRatio)
          case relativeHumidity(RelativeHumidity)
          
          public enum Key: String, RouteKey {
            case altitude
            case humidityRatio
            case relativeHumidity
          }

          public struct Altitude: Codable, Equatable, Sendable {
            public var altitude: Length
            public var dryBulb: DryBulb
            public var humidity: SharedModels.RelativeHumidity
            public var units: PsychrometricUnits?

            public init(
              altitude: Length,
              dryBulb: DryBulb,
              humidity: SharedModels.RelativeHumidity,
              units: PsychrometricUnits? = nil
            ) {
              self.altitude = altitude
              self.dryBulb = dryBulb
              self.humidity = humidity
              self.units = units
            }
          }

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

          public struct RelativeHumidity: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb
            public var humidity: SharedModels.RelativeHumidity
            public var totalPressure: TotalPressure
            public var units: PsychrometricUnits?

            public init(
              dryBulb: DryBulb,
              humidity: SharedModels.RelativeHumidity,
              totalPressure: TotalPressure,
              units: PsychrometricUnits? = nil
            ) {
              self.dryBulb = dryBulb
              self.humidity = humidity
              self.totalPressure = totalPressure
              self.units = units
            }
          }
        }
      }

      // MARK: - Vapor Pressure
      public enum VaporPressure: Codable, Equatable, Sendable {
        case humidityRatio(HumidityRatio)
        
        public enum Key: String, RouteKey {
          case humidityRatio
        }
        
        public struct HumidityRatio: Codable, Equatable, Sendable {
          public var humidityRatio: SharedModels.HumidityRatio
          public var totalPressure: TotalPressure
          public var unit: PsychrometricUnits?

          public init(
            humidityRatio: SharedModels.HumidityRatio,
            totalPressure: TotalPressure,
            unit: PsychrometricUnits? = nil
          ) {
            self.humidityRatio = humidityRatio
            self.totalPressure = totalPressure
            self.unit = unit
          }
        }
      }

      // MARK: - Wet Bulb
      // TODO: Add altitude
      public enum WetBulb: Codable, Equatable, Sendable {

        case relativeHumidity(RelativeHumidity)
        
        public enum Key: String, RouteKey {
          case relativeHumidity
        }
        
        public struct RelativeHumidity: Codable, Equatable, Sendable {
          public var dryBulb: DryBulb
          public var humidity: SharedModels.RelativeHumidity
          public var totalPressure: TotalPressure
          public var units: PsychrometricUnits?

          public init(
            dryBulb: DryBulb,
            humidity: SharedModels.RelativeHumidity,
            totalPressure: TotalPressure,
            units: PsychrometricUnits? = nil
          ) {
            self.dryBulb = dryBulb
            self.humidity = humidity
            self.totalPressure = totalPressure
            self.units = units
          }
        }
      }

    }
  }
}

// MARK: - Codable
