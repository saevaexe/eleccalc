import SwiftUI

enum CalculationCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case ohmLaw
    case power
    case cableSection
    case voltageDrop
    case compensation
    case transformer
    case grounding
    case shortCircuit
    case motorCalc
    case lighting
    case energyConsumption
    case cableAmpacity
    case breakerSelection
    case unitConverter
    case formulaReference

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ohmLaw:            return String(localized: "category.ohmLaw")
        case .power:             return String(localized: "category.power")
        case .cableSection:      return String(localized: "category.cableSection")
        case .voltageDrop:       return String(localized: "category.voltageDrop")
        case .compensation:      return String(localized: "category.compensation")
        case .transformer:       return String(localized: "category.transformer")
        case .grounding:         return String(localized: "category.grounding")
        case .shortCircuit:      return String(localized: "category.shortCircuit")
        case .motorCalc:         return String(localized: "category.motorCalc")
        case .lighting:          return String(localized: "category.lighting")
        case .energyConsumption: return String(localized: "category.energyConsumption")
        case .cableAmpacity:    return String(localized: "category.cableAmpacity")
        case .breakerSelection: return String(localized: "category.breakerSelection")
        case .unitConverter:     return String(localized: "category.unitConverter")
        case .formulaReference:  return String(localized: "category.formulaReference")
        }
    }

    var subtitle: String {
        switch self {
        case .ohmLaw:            return String(localized: "category.ohmLaw.subtitle")
        case .power:             return String(localized: "category.power.subtitle")
        case .cableSection:      return String(localized: "category.cableSection.subtitle")
        case .voltageDrop:       return String(localized: "category.voltageDrop.subtitle")
        case .compensation:      return String(localized: "category.compensation.subtitle")
        case .transformer:       return String(localized: "category.transformer.subtitle")
        case .grounding:         return String(localized: "category.grounding.subtitle")
        case .shortCircuit:      return String(localized: "category.shortCircuit.subtitle")
        case .motorCalc:         return String(localized: "category.motorCalc.subtitle")
        case .lighting:          return String(localized: "category.lighting.subtitle")
        case .energyConsumption: return String(localized: "category.energyConsumption.subtitle")
        case .cableAmpacity:    return String(localized: "category.cableAmpacity.subtitle")
        case .breakerSelection: return String(localized: "category.breakerSelection.subtitle")
        case .unitConverter:     return String(localized: "category.unitConverter.subtitle")
        case .formulaReference:  return String(localized: "category.formulaReference.subtitle")
        }
    }

    var iconName: String {
        switch self {
        case .ohmLaw:            return "bolt.circle.fill"
        case .power:             return "powerplug.fill"
        case .cableSection:      return "cable.connector"
        case .voltageDrop:       return "arrow.down.right.circle.fill"
        case .compensation:      return "gauge.with.dots.needle.33percent"
        case .transformer:       return "square.stack.3d.up.fill"
        case .grounding:         return "arrow.down.to.line"
        case .shortCircuit:      return "bolt.trianglebadge.exclamationmark"
        case .motorCalc:         return "gearshape.2.fill"
        case .lighting:          return "lightbulb.fill"
        case .energyConsumption: return "chart.bar.fill"
        case .cableAmpacity:    return "flame.fill"
        case .breakerSelection: return "shield.checkered"
        case .unitConverter:     return "arrow.left.arrow.right.circle.fill"
        case .formulaReference:  return "book.fill"
        }
    }

    var color: Color {
        switch self {
        case .ohmLaw:            return AppTheme.CategoryColor.ohmLaw
        case .power:             return AppTheme.CategoryColor.power
        case .cableSection:      return AppTheme.CategoryColor.cableSection
        case .voltageDrop:       return AppTheme.CategoryColor.voltageDrop
        case .compensation:      return AppTheme.CategoryColor.compensation
        case .transformer:       return AppTheme.CategoryColor.transformer
        case .grounding:         return AppTheme.CategoryColor.grounding
        case .shortCircuit:      return AppTheme.CategoryColor.shortCircuit
        case .motorCalc:         return AppTheme.CategoryColor.motorCalc
        case .lighting:          return AppTheme.CategoryColor.lighting
        case .energyConsumption: return AppTheme.CategoryColor.energyConsumption
        case .cableAmpacity:    return AppTheme.CategoryColor.cableAmpacity
        case .breakerSelection: return AppTheme.CategoryColor.breakerSelection
        case .unitConverter:     return AppTheme.CategoryColor.unitConverter
        case .formulaReference:  return AppTheme.CategoryColor.formulaReference
        }
    }
}
