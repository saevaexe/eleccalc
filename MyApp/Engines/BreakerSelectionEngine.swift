import Foundation

struct BreakerSelectionEngine {
    /// MCB standart anma akımları (A)
    static let mcbRatings: [Double] = [6, 10, 13, 16, 20, 25, 32, 40, 50, 63]

    /// MCCB standart anma akımları (A)
    static let mccbRatings: [Double] = [
        16, 25, 32, 40, 50, 63, 80, 100, 125, 160,
        200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600
    ]

    /// gG sigorta standart anma akımları (A)
    static let fuseRatings: [Double] = [
        2, 4, 6, 10, 16, 20, 25, 32, 40, 50,
        63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630
    ]

    /// Yük akımı hesabı: Ib = P(kW) × 1000 / (√3 × U × cosφ)  [3 faz]
    ///                    Ib = P(kW) × 1000 / (U × cosφ)        [1 faz]
    static func loadCurrent(powerKW: Double, voltage: Double, cosPhi: Double, isThreePhase: Bool) -> Double {
        if isThreePhase {
            return (powerKW * 1000.0) / (sqrt(3.0) * voltage * cosPhi)
        } else {
            return (powerKW * 1000.0) / (voltage * cosPhi)
        }
    }

    /// Ib ≤ In olan ilk standart MCB değeri
    static func recommendedMCB(loadCurrent: Double) -> Double? {
        mcbRatings.first { $0 >= loadCurrent }
    }

    /// Ib ≤ In olan ilk standart MCCB değeri
    static func recommendedMCCB(loadCurrent: Double) -> Double? {
        mccbRatings.first { $0 >= loadCurrent }
    }

    /// Ib ≤ In olan ilk standart sigorta değeri
    static func recommendedFuse(loadCurrent: Double) -> Double? {
        fuseRatings.first { $0 >= loadCurrent }
    }

    /// Koruma kontrolü: Ib ≤ In ≤ Iz (IEC 60364-4-43)
    static func checkProtection(loadCurrent: Double, breakerRating: Double, cableAmpacity: Double) -> Bool {
        loadCurrent <= breakerRating && breakerRating <= cableAmpacity
    }
}
