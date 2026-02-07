import XCTest
@testable import MyApp

final class GroundingEngineTests: XCTestCase {

    func testRodResistance() {
        // R = ρ / (2πL) × ln(4L/d)
        // ρ=100, L=2.4, d=0.02
        let expected = (100.0 / (2.0 * .pi * 2.4)) * log(4.0 * 2.4 / 0.02)
        let result = GroundingEngine.rodResistance(soilResistivity: 100, length: 2.4, diameter: 0.02)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testRodResistance_differentValues() {
        // ρ=50, L=3.0, d=0.016
        let expected = (50.0 / (2.0 * .pi * 3.0)) * log(4.0 * 3.0 / 0.016)
        let result = GroundingEngine.rodResistance(soilResistivity: 50, length: 3.0, diameter: 0.016)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testPlateResistance() {
        // R = ρ / (4a) = 100 / (4 × 1) = 25 Ω
        XCTAssertEqual(GroundingEngine.plateResistance(soilResistivity: 100, sideLength: 1.0), 25.0, accuracy: 1e-9)
        // R = 200 / (4 × 0.5) = 100 Ω
        XCTAssertEqual(GroundingEngine.plateResistance(soilResistivity: 200, sideLength: 0.5), 100.0, accuracy: 1e-9)
    }

    func testProtectiveConductorSection_copper() {
        // S = I × √t / k = 10000 × √0.4 / 176
        let expected = (10000.0 * sqrt(0.4)) / 176.0
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 10000, clearingTime: 0.4, material: .copper
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testProtectiveConductorSection_aluminum() {
        // S = 5000 × √0.5 / 116
        let expected = (5000.0 * sqrt(0.5)) / 116.0
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 5000, clearingTime: 0.5, material: .aluminum
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testProtectiveConductorSection_steel() {
        // S = 8000 × √0.2 / 78
        let expected = (8000.0 * sqrt(0.2)) / 78.0
        let result = GroundingEngine.protectiveConductorSection(
            faultCurrent: 8000, clearingTime: 0.2, material: .steel
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }
}
