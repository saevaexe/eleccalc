import XCTest
@testable import ElecCalc

final class ShortCircuitEngineTests: XCTestCase {

    func testTotalImpedance() {
        // Z = √(R² + X²) = √(3² + 4²) = 5
        XCTAssertEqual(ShortCircuitEngine.totalImpedance(resistance: 3, reactance: 4), 5.0, accuracy: 1e-9)
    }

    func testShortCircuitCurrent3Phase() {
        // Isc = U / (√3 × Z) = 400 / (√3 × 0.1) = 2309.4 A
        let expected = 400.0 / (sqrt(3.0) * 0.1)
        let result = ShortCircuitEngine.shortCircuitCurrent3Phase(voltage: 400, impedance: 0.1)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testShortCircuitCurrent1Phase() {
        // Isc = U / (2 × Z) = 230 / (2 × 0.05) = 2300 A
        XCTAssertEqual(ShortCircuitEngine.shortCircuitCurrent1Phase(voltage: 230, impedance: 0.05), 2300.0, accuracy: 1e-6)
    }

    func testCableImpedance() {
        // R/km=0.727, X/km=0.08, L=50m
        // r = 0.727 × 50/1000 = 0.03635
        // x = 0.08 × 50/1000 = 0.004
        // Z = √(0.03635² + 0.004²) = 0.03657
        let r = 0.727 * 50.0 / 1000.0
        let x = 0.08 * 50.0 / 1000.0
        let expected = sqrt(r * r + x * x)
        let result = ShortCircuitEngine.cableImpedance(resistancePerKm: 0.727, reactancePerKm: 0.08, lengthM: 50)
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testTransformerImpedance() {
        // Zt = (Uk%/100) × (U²/Sn) = (4/100) × (400²/1000000) = 0.04 × 0.16 = 0.0064 Ω
        let expected = (4.0 / 100.0) * (400.0 * 400.0) / 1_000_000.0
        let result = ShortCircuitEngine.transformerImpedance(ukPercent: 4, secondaryVoltage: 400, nominalPowerVA: 1_000_000)
        XCTAssertEqual(result, expected, accuracy: 1e-9)
    }

    func testPeakShortCircuitCurrent() {
        // ip = κ × √2 × Isc = 1.8 × √2 × 10000 = 25456 A
        let expected = 1.8 * sqrt(2.0) * 10000.0
        let result = ShortCircuitEngine.peakShortCircuitCurrent(rmsCurrent: 10000, kappa: 1.8)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }
}
