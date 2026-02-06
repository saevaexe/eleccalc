import Foundation

enum AppConstants {
    enum Material {
        static let copperResistivity: Double = 0.0175    // Ω·mm²/m at 20°C
        static let aluminumResistivity: Double = 0.028   // Ω·mm²/m at 20°C
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
}
