import SwiftUI

enum CalculationCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case ohmLaw
    case power
    case cableSection
    case voltageDrop

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ohmLaw:       return String(localized: "category.ohmLaw")
        case .power:        return String(localized: "category.power")
        case .cableSection: return String(localized: "category.cableSection")
        case .voltageDrop:  return String(localized: "category.voltageDrop")
        }
    }

    var subtitle: String {
        switch self {
        case .ohmLaw:       return String(localized: "category.ohmLaw.subtitle")
        case .power:        return String(localized: "category.power.subtitle")
        case .cableSection: return String(localized: "category.cableSection.subtitle")
        case .voltageDrop:  return String(localized: "category.voltageDrop.subtitle")
        }
    }

    var iconName: String {
        switch self {
        case .ohmLaw:       return "bolt.circle.fill"
        case .power:        return "powerplug.fill"
        case .cableSection: return "cable.connector"
        case .voltageDrop:  return "arrow.down.right.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .ohmLaw:       return AppTheme.CategoryColor.ohmLaw
        case .power:        return AppTheme.CategoryColor.power
        case .cableSection: return AppTheme.CategoryColor.cableSection
        case .voltageDrop:  return AppTheme.CategoryColor.voltageDrop
        }
    }
}
