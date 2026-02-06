import Foundation

struct TransformerEngine {
    static let standardPowers: [Double] = AppConstants.Transformer.standardPowers

    /// Yüklenme oranı (%)
    static func loadingRate(loadPower: Double, transformerPower: Double) -> Double {
        (loadPower / transformerPower) * 100.0
    }

    /// Nominal akım (A) - üç fazlı
    static func nominalCurrent(transformerPowerKVA: Double, voltageKV: Double) -> Double {
        (transformerPowerKVA * 1000.0) / (sqrt(3.0) * voltageKV * 1000.0)
    }

    /// Bakır kaybı (kW) yük altında
    static func copperLoss(fullLoadCopperLoss: Double, loadingRate: Double) -> Double {
        fullLoadCopperLoss * pow(loadingRate / 100.0, 2)
    }

    /// Toplam kayıp (kW) = demir kaybı + bakır kaybı
    static func totalLoss(ironLoss: Double, copperLoss: Double) -> Double {
        ironLoss + copperLoss
    }

    /// Verim (%)
    static func efficiency(loadPowerKW: Double, totalLossKW: Double) -> Double {
        (loadPowerKW / (loadPowerKW + totalLossKW)) * 100.0
    }
}
