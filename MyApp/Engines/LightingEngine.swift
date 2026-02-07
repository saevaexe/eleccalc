import Foundation

struct LightingEngine {
    /// Aydınlık düzeyi: E = (n × Φ × CU × MF) / A
    static func illuminance(fixtureCount: Int, lumensPerFixture: Double,
                            utilizationFactor: Double, maintenanceFactor: Double,
                            area: Double) -> Double {
        (Double(fixtureCount) * lumensPerFixture * utilizationFactor * maintenanceFactor) / area
    }

    /// Gerekli armatür sayısı: n = (E × A) / (Φ × CU × MF)
    static func requiredFixtures(targetLux: Double, area: Double,
                                 lumensPerFixture: Double,
                                 utilizationFactor: Double,
                                 maintenanceFactor: Double) -> Double {
        (targetLux * area) / (lumensPerFixture * utilizationFactor * maintenanceFactor)
    }

    /// Güç yoğunluğu: W/m² = (n × W) / A
    static func powerDensity(fixtureCount: Int, wattsPerFixture: Double, area: Double) -> Double {
        (Double(fixtureCount) * wattsPerFixture) / area
    }

    /// Toplam lümen: Φ_total = E × A / (CU × MF)
    static func totalLumens(targetLux: Double, area: Double,
                            utilizationFactor: Double, maintenanceFactor: Double) -> Double {
        (targetLux * area) / (utilizationFactor * maintenanceFactor)
    }
}
