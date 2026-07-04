import XCTest
@testable import ElecCalc

final class LightingEngineTests: XCTestCase {

    func testIlluminance() {
        // E = (n × Φ × CU × MF) / A = (10 × 3000 × 0.65 × 0.8) / 50 = 312 lux
        let result = LightingEngine.illuminance(
            fixtureCount: 10, lumensPerFixture: 3000,
            utilizationFactor: 0.65, maintenanceFactor: 0.8, area: 50
        )
        XCTAssertEqual(result, 312.0, accuracy: 1e-9)
    }

    func testRequiredFixtures() {
        // n = (E × A) / (Φ × CU × MF) = 25000 / 1560 = 16.0256
        let result = LightingEngine.requiredFixtures(
            targetLux: 500, area: 50,
            lumensPerFixture: 3000,
            utilizationFactor: 0.65, maintenanceFactor: 0.8
        )
        XCTAssertEqual(result, 16.0256, accuracy: 1e-3)
    }

    func testPowerDensity() {
        // W/m² = (n × W) / A = (16 × 36) / 50 = 11.52
        let result = LightingEngine.powerDensity(fixtureCount: 16, wattsPerFixture: 36, area: 50)
        XCTAssertEqual(result, 11.52, accuracy: 1e-9)
    }

    func testTotalLumens() {
        // Φ_total = E × A / (CU × MF) = 25000 / 0.52 = 48076.92
        let result = LightingEngine.totalLumens(
            targetLux: 500, area: 50,
            utilizationFactor: 0.65, maintenanceFactor: 0.8
        )
        XCTAssertEqual(result, 48076.92, accuracy: 1e-1)
    }

    func testRoundTrip() {
        // Calculate fixtures, then verify illuminance matches target
        let targetLux = 500.0
        let area = 50.0
        let lumens = 3000.0
        let cu = 0.65
        let mf = 0.8

        let n = LightingEngine.requiredFixtures(
            targetLux: targetLux, area: area,
            lumensPerFixture: lumens,
            utilizationFactor: cu, maintenanceFactor: mf
        )
        let fixtureCount = Int(ceil(n))
        let actualLux = LightingEngine.illuminance(
            fixtureCount: fixtureCount, lumensPerFixture: lumens,
            utilizationFactor: cu, maintenanceFactor: mf, area: area
        )
        XCTAssertGreaterThanOrEqual(actualLux, targetLux)
    }
}
