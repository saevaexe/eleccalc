import Foundation
import SwiftData

enum PowerSolveFor: String, CaseIterable, Hashable {
    case apparentPower
    case activePower
    case reactivePower
    case powerFactor
    case fromKVA

    var title: String {
        switch self {
        case .apparentPower:  return String(localized: "power.apparent")
        case .activePower:    return String(localized: "power.active")
        case .reactivePower:  return String(localized: "power.reactive")
        case .powerFactor:    return String(localized: "power.factor")
        case .fromKVA:        return String(localized: "power.fromKVA")
        }
    }

    var unit: String {
        switch self {
        case .apparentPower:  return "VA"
        case .activePower:    return "W"
        case .reactivePower:  return "VAR"
        case .powerFactor:    return ""
        case .fromKVA:        return ""
        }
    }
}

@Observable
final class PowerViewModel {
    var solveFor: PowerSolveFor = .apparentPower {
        didSet {
            if oldValue != solveFor {
                result = nil
                kvaActivePower = nil
                kvaReactivePower = nil
                kvaCurrent = nil
                hasCalculated = false
            }
        }
    }
    var voltageText: String = ""
    var currentText: String = ""
    var powerFactorText: String = "0,85"
    var activePowerText: String = ""
    var apparentPowerText: String = ""
    var isThreePhase: Bool = false

    var result: Double?
    var formulaUsed: String = ""
    var hasCalculated: Bool = false

    // kVA → sonuçlar
    var kvaActivePower: Double?
    var kvaReactivePower: Double?
    var kvaCurrent: Double?

    var canCalculate: Bool {
        switch solveFor {
        case .apparentPower:  return parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        case .activePower:    return parseDouble(voltageText) != nil && parseDouble(currentText) != nil && parseDouble(powerFactorText) != nil
        case .reactivePower:  return parseDouble(voltageText) != nil && parseDouble(currentText) != nil && parseDouble(powerFactorText) != nil
        case .powerFactor:    return parseDouble(activePowerText) != nil && parseDouble(voltageText) != nil && parseDouble(currentText) != nil
        case .fromKVA:        return parseDouble(apparentPowerText) != nil && parseDouble(voltageText) != nil && parseDouble(powerFactorText) != nil
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
            if let r = result { activePowerText = formatForInput(r) }
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
            if let r = result { powerFactorText = formatForInput(r) }
        case .fromKVA:
            guard let sKVA = parseDouble(apparentPowerText), let v = parseDouble(voltageText), let pf = parseDouble(powerFactorText) else { return }
            let sVA = sKVA * 1000.0
            kvaActivePower = PowerEngine.activePower(apparentPower: sVA, powerFactor: pf) / 1000.0  // kW
            kvaReactivePower = PowerEngine.reactivePower(apparentPower: sVA, powerFactor: pf) / 1000.0  // kVAR
            kvaCurrent = v > 0 ? sVA / (sqrt(3.0) * v) : nil  // 3 faz akım
            formulaUsed = "P = S × cosφ, Q = S × sinφ, I = S / (√3 × V)"
        }
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        let record: CalculationRecord
        if solveFor == .fromKVA, let p = kvaActivePower {
            record = CalculationRecord(
                category: .power,
                title: "\(solveFor.title)",
                inputSummary: "S=\(apparentPowerText)kVA, V=\(voltageText)V",
                resultSummary: "P = \(p.formatted2) kW"
            )
        } else {
            guard let result else { return }
            record = CalculationRecord(
                category: .power,
                title: "\(solveFor.title)",
                inputSummary: "V=\(voltageText), I=\(currentText)",
                resultSummary: "\(solveFor.title) = \(result.formatted2) \(solveFor.unit)"
            )
        }
        modelContext.insert(record)
    }

    func clear() {
        voltageText = ""
        currentText = ""
        powerFactorText = "0,85"
        activePowerText = ""
        apparentPowerText = ""
        result = nil
        kvaActivePower = nil
        kvaReactivePower = nil
        kvaCurrent = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }

    private func formatForInput(_ value: Double) -> String {
        String(value).replacingOccurrences(of: ".", with: ",")
    }
}
