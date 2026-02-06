import Foundation

struct CompensationEngine {
    static let standardCapacitors: [Double] = AppConstants.StandardCapacitors.kvar

    /// Gerekli reaktif güç: Qc = P × (tanφ₁ - tanφ₂)
    static func requiredReactivePower(
        activePower: Double,
        currentCosPhi: Double,
        targetCosPhi: Double
    ) -> Double {
        let phi1 = acos(currentCosPhi)
        let phi2 = acos(targetCosPhi)
        return activePower * (tan(phi1) - tan(phi2))
    }

    /// Standart kondansatör gücü seçimi
    static func recommendedCapacitor(requiredKVAR: Double) -> Double? {
        standardCapacitors.first { $0 >= requiredKVAR }
    }

    /// Kompanzasyon sonrası yeni cosφ
    static func newCosPhi(
        activePower: Double,
        currentCosPhi: Double,
        installedKVAR: Double
    ) -> Double {
        let phi1 = acos(currentCosPhi)
        let currentQ = activePower * tan(phi1)
        let newQ = currentQ - installedKVAR
        let apparentPower = sqrt(activePower * activePower + newQ * newQ)
        return activePower / apparentPower
    }
}
