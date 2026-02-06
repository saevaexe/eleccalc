import Foundation

enum ConductorMaterial: String, CaseIterable, Hashable {
    case copper
    case aluminum

    var resistivity: Double {
        switch self {
        case .copper:    return AppConstants.Material.copperResistivity
        case .aluminum:  return AppConstants.Material.aluminumResistivity
        }
    }

    var title: String {
        switch self {
        case .copper:    return String(localized: "material.copper")
        case .aluminum:  return String(localized: "material.aluminum")
        }
    }
}

enum PhaseConfiguration: String, CaseIterable, Hashable {
    case singlePhase
    case threePhase

    var title: String {
        switch self {
        case .singlePhase: return String(localized: "phase.single")
        case .threePhase:  return String(localized: "phase.three")
        }
    }

    var factor: Double {
        switch self {
        case .singlePhase: return 2.0
        case .threePhase:  return sqrt(3.0)
        }
    }
}

struct CableSectionEngine {
    static let standardSections: [Double] = AppConstants.StandardCableSections.iec

    static func minimumCrossSection(
        current: Double,
        length: Double,
        material: ConductorMaterial,
        voltage: Double,
        maxDropPercent: Double,
        phaseConfig: PhaseConfiguration
    ) -> Double {
        let maxDrop = voltage * (maxDropPercent / 100.0)
        return (material.resistivity * length * current * phaseConfig.factor) / maxDrop
    }

    static func recommendedSection(minimumSection: Double) -> Double? {
        standardSections.first { $0 >= minimumSection }
    }
}
