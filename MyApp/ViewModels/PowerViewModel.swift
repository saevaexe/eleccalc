import Foundation
import SwiftData

enum PowerSolveFor: String, CaseIterable, Hashable {
    case apparentPower
    case activePower
    case reactivePower
    case powerFactor

    var title: String {
        switch self {
        case .apparentPower:  return String(localized: "power.apparent")
        case .activePower:    return String(localized: "power.active")
        case .reactivePower:  return String(localized: "power.reactive")
        case .powerFactor:    return String(localized: "power.factor")
        }
    }

    var unit: ElectricalUnit {
        switch self {
        case .apparentPower:  return .voltAmpere
        case .activePower:    return .watt
        case .reactivePower:  return .kVAR
        case .powerFactor:    return .percent
        }
    }
}

@Observable
final class PowerViewModel {
    var solveFor: PowerSolveFor = .apparentPower
    var voltageText: String = ""
    var currentText: String = ""
    var powerFactorText: String = ""
    var activePowerText: String = ""
    var isThreePhase: Bool = false

    var result: Double?
    var formulaUsed: String = ""
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        switch solveFor {
        case .apparentPower:  return parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        case .activePower:    return parseDouble(voltageText) != nil && parseDouble(currentText) != nil && parseDouble(powerFactorText) != nil
        case .reactivePower:  return parseDouble(voltageText) != nil && parseDouble(currentText) != nil && parseDouble(powerFactorText) != nil
        case .powerFactor:    return parseDouble(activePowerText) != nil && parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        }
    }

    func calculate() {
        switch solveFor {
        case .apparentPower:
            guard let v = parseDouble(voltageText), let i = parseDouble(currentText) else { return }
            if isThreePhase {
                result = PowerEngine.threePhaseApparentPower(lineVoltage: v, lineCurrent: i)
                formulaUsed = "S = √3 × V × I"
            } else {
                result = PowerEngine.apparentPower(voltage: v, current: i)
                formulaUsed = "S = V × I"
            }
        case .activePower:
            guard let v = parseDouble(voltageText), let i = parseDouble(currentText), let pf = parseDouble(powerFactorText) else { return }
            if isThreePhase {
                result = PowerEngine.threePhaseActivePower(lineVoltage: v, lineCurrent: i, powerFactor: pf)
                formulaUsed = "P = √3 × V × I × cosφ"
            } else {
                let s = PowerEngine.apparentPower(voltage: v, current: i)
                result = PowerEngine.activePower(apparentPower: s, powerFactor: pf)
                formulaUsed = "P = S × cosφ"
            }
        case .reactivePower:
            guard let v = parseDouble(voltageText), let i = parseDouble(currentText), let pf = parseDouble(powerFactorText) else { return }
            let s = isThreePhase
                ? PowerEngine.threePhaseApparentPower(lineVoltage: v, lineCurrent: i)
                : PowerEngine.apparentPower(voltage: v, current: i)
            result = PowerEngine.reactivePower(apparentPower: s, powerFactor: pf)
            formulaUsed = "Q = S × sinφ"
        case .powerFactor:
            guard let p = parseDouble(activePowerText), let v = parseDouble(voltageText), let i = parseDouble(currentText) else { return }
            let s = isThreePhase
                ? PowerEngine.threePhaseApparentPower(lineVoltage: v, lineCurrent: i)
                : PowerEngine.apparentPower(voltage: v, current: i)
            guard s > 0 else { return }
            result = PowerEngine.powerFactor(activePower: p, apparentPower: s)
            formulaUsed = "cosφ = P / S"
        }
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let result else { return }
        let record = CalculationRecord(
            category: .power,
            title: "\(solveFor.title)",
            inputSummary: "V=\(voltageText), I=\(currentText)",
            resultSummary: "\(solveFor.title) = \(result.formatted2) \(solveFor.unit.symbol)"
        )
        modelContext.insert(record)
    }

    func clear() {
        voltageText = ""
        currentText = ""
        powerFactorText = ""
        activePowerText = ""
        result = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
