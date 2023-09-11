import Tagged

// TODO: Group Routes based on `Moist` or `Dry` air.

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
      case dryAir(DryAir.Route)
      case moistAir(MoistAir.Route)
      case water(Water.Route)

      public enum DryAir {
        public enum Route: Codable, Equatable, Sendable {
          case density(Self.Density.Route)
          case enthalpy(Self.Enthalpy)
          case specificVolume(Self.SpecificVolume)

          public enum Density {
            public enum Route: Codable, Equatable, Sendable {
              case altitude(Self.Altitude)
              case totalPressure(Self.Pressure)

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
          }

          public struct Enthalpy: Codable, Equatable, Sendable {
            public var dryBulb: SharedModels.DryBulb
            public var units: PsychrometricUnits?

            public init(dryBulb: SharedModels.DryBulb, units: PsychrometricUnits? = nil) {
              self.dryBulb = dryBulb
              self.units = units
            }
          }

          public struct SpecificVolume: Codable, Equatable, Sendable {
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
      }

      // MARK: - Moist Air
      public enum MoistAir {
        public enum Route: Codable, Equatable, Sendable {
          case density(Self.Density.Route)
          case dewPoint(Self.DewPoint.Route)
          case enthalpy(Self.Enthalpy.Route)
          case grainsOfMoisture(Self.GrainsOfMoisture.Route)
          case humidityRatio(Self.HumidityRatio.Route)
          case psychrometrics(Self.Psychrometrics.Route)
          case relativeHumidity(Self.RelativeHumidity.Route)
          case specificVolume(Self.SpecificVolume.Route)
          case vaporPressure(Self.VaporPressure.Route)
          case wetBulb(Self.WetBulb.Route)

          public enum Density {
            public enum Route: Codable, Equatable, Sendable {
              case humidityRatio(Self.HumidityRatio)
              case relativeHumidity(Self.RelativeHumidity)
              case specificVolume(Self.SpecificVolume)

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

          public enum DewPoint {
            public enum Route: Codable, Equatable, Sendable {
              case temperature(Self.Temperature)
              case vaporPressure(Self.VaporPressure)
              case wetBulb(Self.WetBulb)

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
          }

          public enum Enthalpy {
            public enum Route: Codable, Equatable, Sendable {
              case altitude(Self.Altitude)
              case totalPressure(Self.Pressure)

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

          public enum GrainsOfMoisture {
            public enum Route: Codable, Equatable, Sendable {
              case altitude(Self.Altitude)
              case temperature(Self.Temperature)
              case totalPressure(Self.Pressure)

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
                public var dryBulb: DryBulb
                public var humidity: SharedModels.RelativeHumidity
                public var totalPressure: SharedModels.TotalPressure

                public init(
                  dryBulb: SharedModels.DryBulb,
                  humidity: SharedModels.RelativeHumidity,
                  totalPressure: SharedModels.TotalPressure
                ) {
                  self.dryBulb = dryBulb
                  self.humidity = humidity
                  self.totalPressure = totalPressure
                }
              }
            }
          }

          public enum HumidityRatio {
            public enum Route: Codable, Equatable, Sendable {
              case dewPoint(Self.DewPoint)
              case enthalpy(Self.Enthalpy)
              case pressure(Self.Pressure.Route)
              case specificHumidity(Self.SpecificHumidity)
              case wetBulb(Self.WetBulb)

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
                public var enthalpy: EnthalpyOf<MoistAir>
                public var dryBulb: DryBulb

                public init(
                  dryBulb: DryBulb,
                  enthalpy: EnthalpyOf<MoistAir>
                ) {
                  self.enthalpy = enthalpy
                  self.dryBulb = dryBulb
                }
              }

              public enum Pressure {
                public enum Route: Codable, Equatable, Sendable {
                  case saturation(Self.Saturation)
                  case vapor(Self.Vapor)

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
          }

          // TODO: Add altitude
          public enum Psychrometrics {
            public enum Route: Codable, Equatable, Sendable {
              case altitude(Self.Altitude)
              case dewPoint(Self.DewPoint)
              case relativeHumidity(Self.RelativeHumidity)
              case wetBulb(Self.WetBulb)

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
          }

          public enum RelativeHumidity {
            public enum Route: Codable, Equatable, Sendable {
              case humidityRatio(Self.HumidityRatio)
              case vaporPressure(Self.VaporPressure)

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
          }

          public enum SpecificVolume {
            public enum Route: Codable, Equatable, Sendable {
              case altitude(Self.Altitude)
              case humidityRatio(Self.HumidityRatio)
              case relativeHumidity(Self.RelativeHumidity)

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

          public enum VaporPressure {
            public enum Route: Codable, Equatable, Sendable {
              case humidityRatio(Self.HumidityRatio)

              public struct HumidityRatio: Codable, Equatable, Sendable {
                public var humidityRatio: SharedModels.HumidityRatio
                public var totalPressure: TotalPressure
                public var units: PsychrometricUnits?

                public init(
                  humidityRatio: SharedModels.HumidityRatio,
                  totalPressure: TotalPressure,
                  units: PsychrometricUnits? = nil
                ) {
                  self.humidityRatio = humidityRatio
                  self.totalPressure = totalPressure
                  self.units = units
                }
              }
            }
          }

          // MARK: - Wet Bulb
          // TODO: Add altitude
          // TODO: add humidity ratio
          public enum WetBulb {
            public enum Route: Codable, Equatable, Sendable {
              case relativeHumidity(Self.RelativeHumidity)

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

      // MARK: - Water
      public enum Water {
        public enum Route: Codable, Equatable, Sendable {
          case density(Self.Density)
          case specificHeat(Self.SpecificHeat)

          public struct Density: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb

            public init(dryBulb: DryBulb) {
              self.dryBulb = dryBulb
            }
          }

          public struct SpecificHeat: Codable, Equatable, Sendable {
            public var dryBulb: DryBulb

            public init(dryBulb: DryBulb) {
              self.dryBulb = dryBulb
            }
          }
        }
      }
    }
  }
}
