import Foundation
import SwiftData

@Observable
final class MotorCalcViewModel {
    var motorPowerText: String = ""
    var voltageText: String = "400"
    var cosPhiText: String = "0,85"
    var efficiencyText: String = "0,9"
    var startingFactorText: String = "6"
    var rpmText: String = "1500"

    var nominalCurrent: Double?
    var startingCurrent: Double?
    var torque: Double?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        parseDouble(motorPowerText) != nil &&
        parseDouble(voltageText) != nil &&
        parseDouble(cosPhiText) != nil &&
        parseDouble(efficiencyText) != nil
    }

    func calculate() {
        guard let power = parseDouble(motorPowerText),
              let voltage = parseDouble(voltageText),
              let cosPhi = parseDouble(cosPhiText),
              let eff = parseDouble(efficiencyText) else { return }

        nominalCurrent = MotorCalcEngine.nominalCurrent(
            powerKW: power, voltage: voltage, powerFactor: cosPhi, efficiency: eff
        )

        if let inCurrent = nominalCurrent, let kLR = parseDouble(startingFactorText) {
            startingCurrent = MotorCalcEngine.startingCurrent(nominalCurrent: inCurrent, startingFactor: kLR)
        }

        if let rpm = parseDouble(rpmText), rpm > 0 {
            torque = MotorCalcEngine.torque(powerKW: power, rpm: rpm)
        }

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let inCurrent = nominalCurrent else { return }
        let record = CalculationRecord(
            category: .motorCalc,
            title: String(localized: "category.motorCalc"),
            inputSummary: "P=\(motorPowerText)kW, U=\(voltageText)V",
            resultSummary: "In = \(inCurrent.formatted2) A"
        )
        modelContext.insert(record)
    }

    func clear() {
        motorPowerText = ""
        voltageText = "400"
        cosPhiText = "0,85"
        efficiencyText = "0,9"
        startingFactorText = "6"
        rpmText = "1500"
        nominalCurrent = nil
        startingCurrent = nil
        torque = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
