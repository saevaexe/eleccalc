import Foundation
import SwiftData

@Observable
final class VoltageDropViewModel {
    var currentText: String = ""
    var lengthText: String = ""
    var crossSectionText: String = ""
    var voltageText: String = "230"
    var material: ConductorMaterial = .copper
    var phaseConfig: PhaseConfiguration = .singlePhase

    var voltageDrop: Double?
    var voltageDropPercent: Double?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        parseDouble(currentText) != nil &&
        parseDouble(lengthText) != nil &&
        parseDouble(crossSectionText) != nil &&
        parseDouble(voltageText) != nil
    }

    func calculate() {
        guard let current = parseDouble(currentText),
              let length = parseDouble(lengthText),
              let section = parseDouble(crossSectionText),
              let voltage = parseDouble(voltageText),
              section > 0 else { return }

        voltageDrop = VoltageDropEngine.voltageDrop(
            current: current, length: length, crossSection: section,
            material: material, phaseConfig: phaseConfig
        )
        voltageDropPercent = VoltageDropEngine.voltageDropPercent(
            voltageDrop: voltageDrop!, systemVoltage: voltage
        )
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let drop = voltageDrop, let percent = voltageDropPercent else { return }
        let record = CalculationRecord(
            category: .voltageDrop,
            title: String(localized: "category.voltageDrop"),
            inputSummary: "I=\(currentText)A, L=\(lengthText)m, S=\(crossSectionText)mm²",
            resultSummary: "ΔV = \(drop.formatted2) V (%\(percent.formatted2))"
        )
        modelContext.insert(record)
    }

    func clear() {
        currentText = ""
        lengthText = ""
        crossSectionText = ""
        voltageText = "230"
        voltageDrop = nil
        voltageDropPercent = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
