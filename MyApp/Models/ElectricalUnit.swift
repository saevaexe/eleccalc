import Foundation

enum ElectricalUnit: String, Codable, CaseIterable {
    case volt       = "V"
    case ampere     = "A"
    case ohm        = "Ω"
    case watt       = "W"
    case kiloWatt   = "kW"
    case voltAmpere = "VA"
    case kVAR       = "kVAR"
    case mm2        = "mm²"
    case meter      = "m"
    case percent    = "%"

    var symbol: String { rawValue }
}
