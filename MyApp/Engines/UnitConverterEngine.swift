import Foundation

enum UnitCategory: String, CaseIterable, Hashable {
    case voltage
    case current
    case power
    case resistance
    case capacitance

    var title: String {
        switch self {
        case .voltage:     return String(localized: "unitCategory.voltage")
        case .current:     return String(localized: "unitCategory.current")
        case .power:       return String(localized: "unitCategory.power")
        case .resistance:  return String(localized: "unitCategory.resistance")
        case .capacitance: return String(localized: "unitCategory.capacitance")
        }
    }

    var units: [ElectricalUnit] {
        switch self {
        case .voltage:     return [.milliVolt, .volt, .kiloVolt]
        case .current:     return [.milliAmpere, .ampere, .kiloAmpere]
        case .power:       return [.watt, .kiloWatt, .megaWatt]
        case .resistance:  return [.milliOhm, .ohm, .kiloOhm, .megaOhm]
        case .capacitance: return [.picoFarad, .nanoFarad, .microFarad]
        }
    }
}

struct UnitConverterEngine {
    /// Birim dönüştürme - her birimi temel birime (V, A, W, Ω, F) çevir
    static func toBase(_ value: Double, from unit: ElectricalUnit) -> Double {
        switch unit {
        case .milliVolt:    return value * 1e-3
        case .volt:         return value
        case .kiloVolt:     return value * 1e3
        case .milliAmpere:  return value * 1e-3
        case .ampere:       return value
        case .kiloAmpere:   return value * 1e3
        case .watt:         return value
        case .kiloWatt:     return value * 1e3
        case .megaWatt:     return value * 1e6
        case .milliOhm:     return value * 1e-3
        case .ohm:          return value
        case .kiloOhm:      return value * 1e3
        case .megaOhm:      return value * 1e6
        case .picoFarad:    return value * 1e-12
        case .nanoFarad:    return value * 1e-9
        case .microFarad:   return value * 1e-6
        default:            return value
        }
    }

    /// Temel birimden hedef birime çevir
    static func fromBase(_ value: Double, to unit: ElectricalUnit) -> Double {
        switch unit {
        case .milliVolt:    return value * 1e3
        case .volt:         return value
        case .kiloVolt:     return value * 1e-3
        case .milliAmpere:  return value * 1e3
        case .ampere:       return value
        case .kiloAmpere:   return value * 1e-3
        case .watt:         return value
        case .kiloWatt:     return value * 1e-3
        case .megaWatt:     return value * 1e-6
        case .milliOhm:     return value * 1e3
        case .ohm:          return value
        case .kiloOhm:      return value * 1e-3
        case .megaOhm:      return value * 1e-6
        case .picoFarad:    return value * 1e12
        case .nanoFarad:    return value * 1e9
        case .microFarad:   return value * 1e6
        default:            return value
        }
    }

    /// Kaynak birimden hedef birime dönüştür
    static func convert(_ value: Double, from source: ElectricalUnit, to target: ElectricalUnit) -> Double {
        let base = toBase(value, from: source)
        return fromBase(base, to: target)
    }
}
