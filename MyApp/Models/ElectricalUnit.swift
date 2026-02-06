import Foundation

enum ElectricalUnit: String, Codable, CaseIterable {
    case volt       = "V"
    case milliVolt  = "mV"
    case kiloVolt   = "kV"
    case ampere     = "A"
    case milliAmpere = "mA"
    case kiloAmpere = "kA"
    case ohm        = "Ω"
    case milliOhm   = "mΩ"
    case kiloOhm    = "kΩ"
    case megaOhm    = "MΩ"
    case ohmMeter   = "Ω·m"
    case watt       = "W"
    case kiloWatt   = "kW"
    case megaWatt   = "MW"
    case voltAmpere = "VA"
    case kiloVA     = "kVA"
    case megaVA     = "MVA"
    case kVAR       = "kVAR"
    case mm2        = "mm²"
    case meter      = "m"
    case percent    = "%"
    case hertz      = "Hz"
    case microFarad = "μF"
    case nanoFarad  = "nF"
    case picoFarad  = "pF"

    var symbol: String { rawValue }
}
