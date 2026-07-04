import XCTest
@testable import ElecCalc

final class ShortCircuitEngineTests: XCTestCase {

    func testTotalImpedance() {
        // Z = √(R² + X²) = √(3² + 4²) = 5
        XCTAssertEqual(ShortCircuitEngine.totalImpedance(resistance: 3, reactance: 4), 5.0, accuracy: 1e-9)
    }

    func testShortCircuitCurrent3Phase() {
        // Isc = U / (√3 × Z) = 400 / (√3 × 0.1) = 2309.401 A
        let result = ShortCircuitEngine.shortCircuitCurrent3Phase(voltage: 400, impedance: 0.1)
        XCTAssertEqual(result, 2309.401, accuracy: 1e-2)
    }

    func testShortCircuitCurrent1Phase() {
        // Isc = U / (2 × Z) = 230 / (2 × 0.05) = 2300 A
        XCTAssertEqual(ShortCircuitEngine.shortCircuitCurrent1Phase(voltage: 230, impedance: 0.05), 2300.0, accuracy: 1e-6)
    }

    func testCableImpedance() {
        // R/km=0.727, X/km=0.08, L=50m → Z = √(0.03635² + 0.004²) = 0.0365694 Ω
        let result = ShortCircuitEngine.cableImpedance(resistancePerKm: 0.727, reactancePerKm: 0.08, lengthM: 50)
        XCTAssertEqual(result, 0.0365694, accuracy: 1e-6)
    }

    func testTransformerImpedance() {
        // Zt = (Uk%/100) × (U²/Sn) = (4/100) × (400²/1000000) = 0.0064 Ω
        let result = ShortCircuitEngine.transformerImpedance(ukPercent: 4, secondaryVoltage: 400, nominalPowerVA: 1_000_000)
        XCTAssertEqual(result, 0.0064, accuracy: 1e-9)
    }

    func testCombinedImpedance() {
        // Zt=0.0064 (≈Xt), Rc=0.727×50/1000=0.03635, Xc=0.08×50/1000=0.004
        // Zk = √(0.03635² + (0.0064+0.004)²) = 0.0378085 Ω
        let result = ShortCircuitEngine.combinedImpedance(
            transformerImpedance: 0.0064,
            resistancePerKm: 0.727, reactancePerKm: 0.08, lengthM: 50
        )
        XCTAssertEqual(result, 0.0378085, accuracy: 1e-6)
    }

    func testCombinedImpedance_lessThanScalarSum() {
        // Kompleks toplam skaler toplamdan her zaman küçük veya eşittir
        let zt = ShortCircuitEngine.transformerImpedance(ukPercent: 4, secondaryVoltage: 400, nominalPowerVA: 630_000)
        let zCable = ShortCircuitEngine.cableImpedance(resistancePerKm: 0.727, reactancePerKm: 0.08, lengthM: 80)
        let combined = ShortCircuitEngine.combinedImpedance(
            transformerImpedance: zt,
            resistancePerKm: 0.727, reactancePerKm: 0.08, lengthM: 80
        )
        XCTAssertLessThan(combined, zt + zCable)
        XCTAssertGreaterThan(combined, max(zt, zCable))
    }

    func testPeakShortCircuitCurrent() {
        // ip = κ × √2 × Isc = 1.8 × √2 × 10000 = 25455.84 A
        let result = ShortCircuitEngine.peakShortCircuitCurrent(rmsCurrent: 10000, kappa: 1.8)
        XCTAssertEqual(result, 25455.84, accuracy: 1e-1)
    }
}
