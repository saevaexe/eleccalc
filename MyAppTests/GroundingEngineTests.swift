import XCTest
@testable import ElecCalc

final class GroundingEngineTests: XCTestCase {

    func testRodResistance() {
        // R = ρ / (2πL) × ln(4L/d) = 100/(2π×2.4) × ln(480) = 40.9412 Ω
        let result = GroundingEngine.rodResistance(soilResistivity: 100, length: 2.4, diameter: 0.02)
        XCTAssertEqual(result, 40.9412, accuracy: 1e-3)
    }

    func testRodResistance_differentValues() {
        // R = 50/(2π×3.0) × ln(750) = 17.5603 Ω
        let result = GroundingEngine.rodResistance(soilResistivity: 50, length: 3.0, diameter: 0.016)
        XCTAssertEqual(result, 17.5603, accuracy: 1e-3)
    }

    func testPlateResistance() {
        // R = ρ / (4a) = 100 / (4 × 1) = 25 Ω
        XCTAssertEqual(GroundingEngine.plateResistance(soilResistivity: 100, sideLength: 1.0), 25.0, accuracy: 1e-9)
        // R = 200 / (4 × 0.5) = 100 Ω
        XCTAssertEqual(GroundingEngine.plateResistance(soilResistivity: 200, sideLength: 0.5), 100.0, accuracy: 1e-9)
    }

    func testProtectiveConductorSection_copper() {
        // S = I × √t / k = 10000 × √0.4 / 176 = 35.935 mm²
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 10000, clearingTime: 0.4, material: .copper
        )
        XCTAssertEqual(result, 35.935, accuracy: 1e-2)
    }

    func testProtectiveConductorSection_aluminum() {
        // S = 5000 × √0.5 / 116 = 30.479 mm²
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 5000, clearingTime: 0.5, material: .aluminum
        )
        XCTAssertEqual(result, 30.479, accuracy: 1e-2)
    }

    func testProtectiveConductorSection_steel() {
        // S = 8000 × √0.2 / 78 = 45.868 mm²
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 8000, clearingTime: 0.2, material: .steel
        )
        XCTAssertEqual(result, 45.868, accuracy: 1e-2)
    }
}
