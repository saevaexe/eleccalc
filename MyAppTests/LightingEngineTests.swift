import XCTest
@testable import ElecCalc

final class LightingEngineTests: XCTestCase {

    func testIlluminance() {
        // E = (n × Φ × CU × MF) / A = (10 × 3000 × 0.65 × 0.8) / 50 = 312 lux
        let expected = (10.0 * 3000.0 * 0.65 * 0.8) / 50.0
        let result = LightingEngine.illuminance(
            fixtureCount: 10, lumensPerFixture: 3000,
            utilizationFactor: 0.65, maintenanceFactor: 0.8, area: 50
        )
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testRequiredFixtures() {
        // n = (E × A) / (Φ × CU × MF) = (500 × 50) / (3000 × 0.65 × 0.8) = 16.025...
        let expected = (500.0 * 50.0) / (3000.0 * 0.65 * 0.8)
        let result = LightingEngine.requiredFixtures(
            targetLux: 500, area: 50,
            lumensPerFixture: 3000,
            utilizationFactor: 0.65, maintenanceFactor: 0.8
        )
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testPowerDensity() {
        // W/m² = (n × W) / A = (16 × 36) / 50 = 11.52
        let expected = (16.0 * 36.0) / 50.0
        let result = LightingEngine.powerDensity(fixtureCount: 16, wattsPerFixture: 36, area: 50)
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testTotalLumens() {
        // Φ_total = E × A / (CU × MF) = 500 × 50 / (0.65 × 0.8) = 48076.92...
        let expected = (500.0 * 50.0) / (0.65 * 0.8)
        let result = LightingEngine.totalLumens(
            targetLux: 500, area: 50,
            utilizationFactor: 0.65, maintenanceFactor: 0.8
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
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
