import Foundation
import SwiftData

enum OhmLawSolveFor: String, CaseIterable, Hashable {
    case voltage
    case current
    case resistance
    case power

    var title: String {
        switch self {
        case .voltage:    return String(localized: "field.voltage")
        case .current:    return String(localized: "field.current")
        case .resistance: return String(localized: "field.resistance")
        case .power:      return String(localized: "field.power")
        }
    }

    var unit: ElectricalUnit {
        switch self {
        case .voltage:    return .volt
        case .current:    return .ampere
        case .resistance: return .ohm
        case .power:      return .watt
        }
    }
}

@Observable
final class OhmLawViewModel {
    var solveFor: OhmLawSolveFor = .voltage {
        didSet {
            if oldValue != solveFor {
                result = nil
                hasCalculated = false
            }
        }
    }
    var voltageText: String = ""
    var currentText: String = ""
    var resistanceText: String = ""

    var result: Double?
    var formulaUsed: String = ""
    var errorMessage: String?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        switch solveFor {
        case .voltage:    return parseDouble(currentText) != nil && parseDouble(resistanceText) != nil
        case .current:    return parseDouble(voltageText) != nil && parseDouble(resistanceText) != nil
        case .resistance: return parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        case .power:      return parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        }
    }

    func calculate() {
        errorMessage = nil
        switch solveFor {
        case .voltage:
            guard let i = parseDouble(currentText), let r = parseDouble(resistanceText) else { return }
            result = OhmLawEngine.voltage(current: i, resistance: r)
            formulaUsed = "V = I × R"
            if let r = result { voltageText = formatForInput(r) }
        case .current:
            guard let v = parseDouble(voltageText), let r = parseDouble(resistanceText), r > 0 else { return }
            result = OhmLawEngine.current(voltage: v, resistance: r)
            formulaUsed = "I = V / R"
            if let r = result { currentText = formatForInput(r) }
        case .resistance:
            guard let v = parseDouble(voltageText), let i = parseDouble(currentText), i > 0 else { return }
            result = OhmLawEngine.resistance(voltage: v, current: i)
            formulaUsed = "R = V / I"
            if let r = result { resistanceText = formatForInput(r) }
        case .power:
            guard let v = parseDouble(voltageText), let i = parseDouble(currentText) else { return }
            result = OhmLawEngine.power(voltage: v, current: i)
            formulaUsed = "P = V × I"
        }
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let result else { return }
        let record = CalculationRecord(
            category: .ohmLaw,
            title: "Ohm - \(solveFor.title)",
            inputSummary: buildInputSummary(),
            resultSummary: "\(solveFor.title) = \(result.formatted2) \(solveFor.unit.symbol)"
        )
        modelContext.insert(record)
    }

    func clear() {
        voltageText = ""
        currentText = ""
        resistanceText = ""
        result = nil
        errorMessage = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }

    private func formatForInput(_ value: Double) -> String {
        String(value).replacingOccurrences(of: ".", with: ",")
    }

    private func buildInputSummary() -> String {
        var parts: [String] = []
        if let v = parseDouble(voltageText) { parts.append("V = \(v.formatted2) V") }
        if let i = parseDouble(currentText) { parts.append("I = \(i.formatted2) A") }
        if let r = parseDouble(resistanceText) { parts.append("R = \(r.formatted2) Ω") }
        return parts.joined(separator: ", ")
    }
}
