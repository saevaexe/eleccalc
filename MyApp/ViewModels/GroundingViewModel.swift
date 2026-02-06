import Foundation
import SwiftData

enum GroundingCalcType: String, CaseIterable, Hashable {
    case electrodeResistance
    case conductorSection

    var title: String {
        switch self {
        case .electrodeResistance: return String(localized: "grounding.electrodeResistance")
        case .conductorSection:    return String(localized: "grounding.conductorSection")
        }
    }
}

@Observable
final class GroundingViewModel {
    var calcType: GroundingCalcType = .electrodeResistance
    var electrodeType: ElectrodeType = .rod
    var conductorMaterial: GroundConductorMaterial = .copper

    // Elektrot girişleri
    var soilResistivityText: String = ""
    var rodLengthText: String = "2,4"
    var rodDiameterText: String = "0,02"
    var plateSideLengthText: String = "1"

    // PE iletken girişleri
    var faultCurrentText: String = ""
    var clearingTimeText: String = "0,4"

    var result: Double?
    var formulaUsed: String = ""
    var errorMessage: String?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        switch calcType {
        case .electrodeResistance:
            guard let rho = parseDouble(soilResistivityText), rho > 0 else { return false }
            if electrodeType == .rod {
                guard let l = parseDouble(rodLengthText), l > 0,
                      let d = parseDouble(rodDiameterText), d > 0 else { return false }
            } else {
                guard let a = parseDouble(plateSideLengthText), a > 0 else { return false }
            }
            return true
        case .conductorSection:
            guard let i = parseDouble(faultCurrentText), i > 0,
                  let t = parseDouble(clearingTimeText), t > 0 else { return false }
            return true
        }
    }

    func calculate() {
        errorMessage = nil
        switch calcType {
        case .electrodeResistance:
            guard let rho = parseDouble(soilResistivityText) else { return }
            if electrodeType == .rod {
                guard let l = parseDouble(rodLengthText),
                      let d = parseDouble(rodDiameterText) else { return }
                result = GroundingEngine.rodResistance(soilResistivity: rho, length: l, diameter: d)
                formulaUsed = "R = ρ/(2πL) × ln(4L/d)"
            } else {
                guard let a = parseDouble(plateSideLengthText) else { return }
                result = GroundingEngine.plateResistance(soilResistivity: rho, sideLength: a)
                formulaUsed = "R = ρ / (4a)"
            }
        case .conductorSection:
            guard let i = parseDouble(faultCurrentText),
                  let t = parseDouble(clearingTimeText) else { return }
            result = GroundingEngine.protectiveConductorSection(
                faultCurrent: i, clearingTime: t, material: conductorMaterial
            )
            formulaUsed = "S = I×√t / k"
        }
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let result else { return }
        let unitStr = calcType == .electrodeResistance ? "Ω" : "mm²"
        let titleStr = calcType == .electrodeResistance
            ? String(localized: "grounding.electrodeResistance")
            : String(localized: "grounding.conductorSection")
        let record = CalculationRecord(
            category: .grounding,
            title: titleStr,
            inputSummary: buildInputSummary(),
            resultSummary: "\(titleStr) = \(result.formatted2) \(unitStr)"
        )
        modelContext.insert(record)
    }

    func clear() {
        soilResistivityText = ""
        rodLengthText = "2,4"
        rodDiameterText = "0,02"
        plateSideLengthText = "1"
        faultCurrentText = ""
        clearingTimeText = "0,4"
        result = nil
        errorMessage = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }

    private func buildInputSummary() -> String {
        switch calcType {
        case .electrodeResistance:
            return "ρ = \(soilResistivityText) Ω·m, \(electrodeType.title)"
        case .conductorSection:
            return "I = \(faultCurrentText) A, t = \(clearingTimeText) s, \(conductorMaterial.title)"
        }
    }
}
