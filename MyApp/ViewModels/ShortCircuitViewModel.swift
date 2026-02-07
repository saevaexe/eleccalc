import Foundation
import SwiftData

@Observable
final class ShortCircuitViewModel {
    var systemVoltageText: String = "400"
    var transformerPowerText: String = ""
    var ukPercentText: String = "4"
    var cableResistancePerKmText: String = ""
    var cableReactancePerKmText: String = "0,08"
    var cableLengthText: String = ""
    var isThreePhase: Bool = true

    var shortCircuitCurrent: Double?
    var totalImpedance: Double?
    var peakCurrent: Double?
    var formulaUsed: String = ""
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        parseDouble(systemVoltageText) != nil &&
        parseDouble(transformerPowerText) != nil &&
        parseDouble(ukPercentText) != nil
    }

    func calculate() {
        guard let voltage = parseDouble(systemVoltageText),
              let trafoPowerKVA = parseDouble(transformerPowerText),
              let uk = parseDouble(ukPercentText) else { return }

        let trafoPowerVA = trafoPowerKVA * 1000.0
        var zt = ShortCircuitEngine.transformerImpedance(
            ukPercent: uk, secondaryVoltage: voltage, nominalPowerVA: trafoPowerVA
        )

        if let rPerKm = parseDouble(cableResistancePerKmText),
           let xPerKm = parseDouble(cableReactancePerKmText),
           let length = parseDouble(cableLengthText), length > 0 {
            let zCable = ShortCircuitEngine.cableImpedance(
                resistancePerKm: rPerKm, reactancePerKm: xPerKm, lengthM: length
            )
            zt += zCable
        }

        totalImpedance = zt

        if isThreePhase {
            shortCircuitCurrent = ShortCircuitEngine.shortCircuitCurrent3Phase(voltage: voltage, impedance: zt)
            formulaUsed = "Isc = U / (√3 × Zk)"
        } else {
            shortCircuitCurrent = ShortCircuitEngine.shortCircuitCurrent1Phase(voltage: voltage, impedance: zt)
            formulaUsed = "Isc = U / (2 × Zk)"
        }

        if let isc = shortCircuitCurrent {
            peakCurrent = ShortCircuitEngine.peakShortCircuitCurrent(rmsCurrent: isc, kappa: 1.8)
        }

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let isc = shortCircuitCurrent else { return }
        let record = CalculationRecord(
            category: .shortCircuit,
            title: String(localized: "category.shortCircuit"),
            inputSummary: "U=\(systemVoltageText)V, S=\(transformerPowerText)kVA, Uk=\(ukPercentText)%",
            resultSummary: "Isc = \(isc.formatted2) kA"
        )
        modelContext.insert(record)
    }

    func clear() {
        systemVoltageText = "400"
        transformerPowerText = ""
        ukPercentText = "4"
        cableResistancePerKmText = ""
        cableReactancePerKmText = "0,08"
        cableLengthText = ""
        shortCircuitCurrent = nil
        totalImpedance = nil
        peakCurrent = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
