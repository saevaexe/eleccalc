import Foundation

enum ElectrodeType: String, CaseIterable, Hashable {
    case rod
    case plate

    var title: String {
        switch self {
        case .rod:   return String(localized: "electrode.rod")
        case .plate: return String(localized: "electrode.plate")
        }
    }
}

enum GroundConductorMaterial: String, CaseIterable, Hashable {
    case copper
    case aluminum
    case steel

    var kFactor: Double {
        switch self {
        case .copper:   return AppConstants.Grounding.kCopper
        case .aluminum: return AppConstants.Grounding.kAluminum
        case .steel:    return AppConstants.Grounding.kSteel
        }
    }

    var title: String {
        switch self {
        case .copper:   return String(localized: "material.copper")
        case .aluminum: return String(localized: "material.aluminum")
        case .steel:    return String(localized: "material.steel")
        }
    }
}

struct GroundingEngine {
    /// Çubuk elektrot direnci: R = ρ / (2πL) × ln(4L/d)
    static func rodResistance(soilResistivity: Double, length: Double, diameter: Double) -> Double {
        let r = soilResistivity / (2.0 * .pi * length)
        return r * log(4.0 * length / diameter)
    }

    /// Levha elektrot direnci: R = ρ / (4a)
    /// a = levha kenar uzunluğu (kare levha varsayımı)
    static func plateResistance(soilResistivity: Double, sideLength: Double) -> Double {
        soilResistivity / (4.0 * sideLength)
    }

    /// PE iletken kesiti (adiyabatik formül): S = I × √t / k
    static func protectiveConductorSection(
        faultCurrent: Double,
        clearingTime: Double,
        material: GroundConductorMaterial
    ) -> Double {
        (faultCurrent * sqrt(clearingTime)) / material.kFactor
    }
}
