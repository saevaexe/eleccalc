import Foundation
import SwiftData

@Observable
final class CableSectionViewModel {
    var currentText: String = ""
    var lengthText: String = ""
    var voltageText: String = "230"
    var maxDropPercentText: String = "3"
    var material: ConductorMaterial = .copper
    var phaseConfig: PhaseConfiguration = .singlePhase

    var minimumSection: Double?
    var recommendedSection: Double?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        guard let i = parseDouble(currentText), i > 0,
              let l = parseDouble(lengthText), l > 0,
              let v = parseDouble(voltageText), v > 0,
              let d = parseDouble(maxDropPercentText), d > 0 else { return false }
        return true
    }

    func calculate() {
        guard let current = parseDouble(currentText), current > 0,
              let length = parseDouble(lengthText), length > 0,
              let voltage = parseDouble(voltageText), voltage > 0,
              let maxDrop = parseDouble(maxDropPercentText), maxDrop > 0 else { return }

        minimumSection = CableSectionEngine.minimumCrossSection(
            current: current, length: length, material: material,
            voltage: voltage, maxDropPercent: maxDrop, phaseConfig: phaseConfig
        )
        recommendedSection = CableSectionEngine.recommendedSection(minimumSection: minimumSection!)
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let recommended = recommendedSection else { return }
        let record = CalculationRecord(
            category: .cableSection,
            title: String(localized: "category.cableSection"),
            inputSummary: "I=\(currentText)A, L=\(lengthText)m, \(material.title)",
            resultSummary: "\(recommended.formatted2) mm²"
        )
        modelContext.insert(record)
    }

    func clear() {
        currentText = ""
        lengthText = ""
        voltageText = "230"
        maxDropPercentText = "3"
        minimumSection = nil
        recommendedSection = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
