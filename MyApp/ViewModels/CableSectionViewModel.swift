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
        parseDouble(currentText) != nil &&
        parseDouble(lengthText) != nil &&
        parseDouble(voltageText) != nil &&
        parseDouble(maxDropPercentText) != nil
    }

    func calculate() {
        guard let current = parseDouble(currentText),
              let length = parseDouble(lengthText),
              let voltage = parseDouble(voltageText),
              let maxDrop = parseDouble(maxDropPercentText) else { return }

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
