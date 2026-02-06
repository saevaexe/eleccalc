import Foundation
import SwiftData

@Observable
final class TransformerViewModel {
    var transformerPowerText: String = ""
    var loadPowerText: String = ""
    var cosPhiText: String = "0,85"
    var ironLossText: String = ""
    var copperLossText: String = ""
    var secondaryVoltageText: String = "0,4"

    var loadingRate: Double?
    var nominalCurrent: Double?
    var actualCopperLoss: Double?
    var totalLoss: Double?
    var efficiency: Double?
    var errorMessage: String?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        guard let tp = parseDouble(transformerPowerText), tp > 0,
              let lp = parseDouble(loadPowerText), lp > 0,
              let cos = parseDouble(cosPhiText), cos > 0, cos <= 1 else { return false }
        return true
    }

    func calculate() {
        errorMessage = nil
        guard let tp = parseDouble(transformerPowerText),
              let lp = parseDouble(loadPowerText),
              let cos = parseDouble(cosPhiText) else { return }

        let loadKVA = lp / cos
        let rate = TransformerEngine.loadingRate(loadPower: loadKVA, transformerPower: tp)
        loadingRate = rate

        if let secV = parseDouble(secondaryVoltageText), secV > 0 {
            nominalCurrent = TransformerEngine.nominalCurrent(transformerPowerKVA: tp, voltageKV: secV)
        }

        if let pfe = parseDouble(ironLossText), let pcu = parseDouble(copperLossText) {
            let cuLoss = TransformerEngine.copperLoss(fullLoadCopperLoss: pcu, loadingRate: rate)
            actualCopperLoss = cuLoss
            let tLoss = TransformerEngine.totalLoss(ironLoss: pfe, copperLoss: cuLoss)
            totalLoss = tLoss
            efficiency = TransformerEngine.efficiency(loadPowerKW: lp, totalLossKW: tLoss)
        }

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let rate = loadingRate else { return }
        let record = CalculationRecord(
            category: .transformer,
            title: String(localized: "category.transformer"),
            inputSummary: "S = \(transformerPowerText) kVA, P = \(loadPowerText) kW",
            resultSummary: String(localized: "result.loadingRate") + " = \(rate.formatted2)%"
        )
        modelContext.insert(record)
    }

    func clear() {
        transformerPowerText = ""
        loadPowerText = ""
        cosPhiText = "0,85"
        ironLossText = ""
        copperLossText = ""
        secondaryVoltageText = "0,4"
        loadingRate = nil
        nominalCurrent = nil
        actualCopperLoss = nil
        totalLoss = nil
        efficiency = nil
        errorMessage = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
