import Foundation
import SwiftData

enum BreakerInputMode: String, CaseIterable, Hashable {
    case fromCurrent, fromPower
    var title: String {
        switch self {
        case .fromCurrent: String(localized: "input.fromCurrent")
        case .fromPower:   String(localized: "input.fromPower")
        }
    }
}

@Observable
final class BreakerSelectionViewModel {
    var inputMode: BreakerInputMode = .fromPower {
        didSet {
            if oldValue != inputMode {
                loadCurrent = nil
                recommendedMCB = nil
                recommendedMCCB = nil
                recommendedFuse = nil
                protectionOk = nil
                hasCalculated = false
            }
        }
    }

    var loadCurrentText: String = ""
    var powerText: String = ""
    var voltageText: String = "400"
    var cosPhiText: String = "0,85"
    var isThreePhase: Bool = true
    var cableAmpacityText: String = ""

    var loadCurrent: Double?
    var recommendedMCB: Double?
    var recommendedMCCB: Double?
    var recommendedFuse: Double?
    var protectionOk: Bool?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        switch inputMode {
        case .fromCurrent:
            return parseDouble(loadCurrentText) != nil
        case .fromPower:
            return parseDouble(powerText) != nil && parseDouble(voltageText) != nil && parseDouble(cosPhiText) != nil
        }
    }

    func calculate() {
        let ib: Double
        switch inputMode {
        case .fromCurrent:
            guard let current = parseDouble(loadCurrentText) else { return }
            ib = current
        case .fromPower:
            guard let power = parseDouble(powerText),
                  let voltage = parseDouble(voltageText),
                  let cosPhi = parseDouble(cosPhiText) else { return }
            ib = BreakerSelectionEngine.loadCurrent(
                powerKW: power, voltage: voltage, cosPhi: cosPhi, isThreePhase: isThreePhase
            )
        }

        loadCurrent = ib
        recommendedMCB = BreakerSelectionEngine.recommendedMCB(loadCurrent: ib)
        recommendedMCCB = BreakerSelectionEngine.recommendedMCCB(loadCurrent: ib)
        recommendedFuse = BreakerSelectionEngine.recommendedFuse(loadCurrent: ib)

        // Koruma kontrolü (kablo ampasitesi girilmişse)
        if let iz = parseDouble(cableAmpacityText), let inRating = recommendedMCCB ?? recommendedMCB {
            protectionOk = BreakerSelectionEngine.checkProtection(
                loadCurrent: ib, breakerRating: inRating, cableAmpacity: iz
            )
        } else {
            protectionOk = nil
        }

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let ib = loadCurrent else { return }
        let mcbText = recommendedMCB.map { "\(Int($0))A" } ?? "-"
        let record = CalculationRecord(
            category: .breakerSelection,
            title: String(localized: "category.breakerSelection"),
            inputSummary: "Ib = \(ib.formatted2) A",
            resultSummary: "MCB \(mcbText)"
        )
        modelContext.insert(record)
    }

    func clear() {
        loadCurrentText = ""
        powerText = ""
        voltageText = "400"
        cosPhiText = "0,85"
        isThreePhase = true
        cableAmpacityText = ""
        loadCurrent = nil
        recommendedMCB = nil
        recommendedMCCB = nil
        recommendedFuse = nil
        protectionOk = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
