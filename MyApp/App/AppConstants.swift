import Foundation

enum AppConstants {
    enum Material {
        static let copperResistivity20C: Double = 0.0175   // Ω·mm²/m at 20°C (referans)
        static let aluminumResistivity20C: Double = 0.028  // Ω·mm²/m at 20°C (referans)

        // Gerilim düşümü/kesit hesabı iletken işletme sıcaklığında yapılır (PVC ~70°C).
        // ρ70 = ρ20 × (1 + α × 50), α(Cu)=0.00393, α(Al)=0.00403 → 20°C değeriyle hesap ~%20 iyimser kalır.
        static let copperResistivity: Double = 0.0210    // Ω·mm²/m at 70°C
        static let aluminumResistivity: Double = 0.0336  // Ω·mm²/m at 70°C
    }

    enum StandardCableSections {
        static let iec: [Double] = [
            1.5, 2.5, 4, 6, 10, 16, 25, 35, 50, 70, 95, 120, 150, 185, 240, 300
        ]
    }

    enum Voltage {
        static let singlePhase: Double = 230.0
        static let threePhase: Double = 400.0
    }

    enum Transformer {
        static let standardPowers: [Double] = [
            25, 50, 100, 160, 250, 400, 630, 800, 1000, 1250, 1600, 2000, 2500
        ]
    }

    enum Grounding {
        static let kCopper: Double = 176.0
        static let kAluminum: Double = 116.0
        static let kSteel: Double = 78.0
    }

    enum StandardCapacitors {
        static let kvar: [Double] = [
            5, 10, 15, 20, 25, 30, 40, 50, 60, 75, 100, 125, 150, 200, 250, 300
        ]
    }

    enum Subscription {
        static let groupID = "E2FC8D4C-5678-4A5B-9E6F-ABCDEF654321"
        static let monthlyProductID = "com.eleccalc.pro.monthly.v2"
        static let yearlyProductID = "com.eleccalc.pro.yearly.v2"
    }
}
