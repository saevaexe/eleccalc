import Foundation
import SwiftData

@Observable
final class CompensationViewModel {
    var activePowerText: String = ""
    var currentCosPhiText: String = ""
    var targetCosPhiText: String = "0,95"

    var requiredKVAR: Double?
    var recommendedCapacitor: Double?
    var newCosPhi: Double?
    var formulaUsed: String = ""
    var errorMessage: String?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        guard let p = parseDouble(activePowerText), p > 0,
              let cos1 = parseDouble(currentCosPhiText), cos1 > 0, cos1 < 1,
              let cos2 = parseDouble(targetCosPhiText), cos2 > 0, cos2 <= 1,
              cos2 > cos1 else { return false }
        return true
    }

    func calculate() {
        errorMessage = nil
        guard let p = parseDouble(activePowerText),
              let cos1 = parseDouble(currentCosPhiText),
              let cos2 = parseDouble(targetCosPhiText) else { return }

        let qc = CompensationEngine.requiredReactivePower(
            activePower: p,
            currentCosPhi: cos1,
            targetCosPhi: cos2
        )
        requiredKVAR = qc
        recommendedCapacitor = CompensationEngine.recommendedCapacitor(requiredKVAR: qc)
        formulaUsed = "Qc = P × (tanφ₁ - tanφ₂)"

        if let cap = recommendedCapacitor {
            newCosPhi = CompensationEngine.newCosPhi(
                activePower: p,
                currentCosPhi: cos1,
                installedKVAR: cap
            )
        }
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let qc = requiredKVAR else { return }
        let record = CalculationRecord(
            category: .compensation,
            title: String(localized: "category.compensation"),
            inputSummary: "P = \(parseDouble(activePowerText)?.formatted2 ?? "") kW, cosφ₁ = \(currentCosPhiText), cosφ₂ = \(targetCosPhiText)",
            resultSummary: "Qc = \(qc.formatted2) kVAR"
        )
        modelContext.insert(record)
    }

    func clear() {
        activePowerText = ""
        currentCosPhiText = ""
        targetCosPhiText = "0,95"
        requiredKVAR = nil
        recommendedCapacitor = nil
        newCosPhi = nil
        errorMessage = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
