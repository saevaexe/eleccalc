import XCTest
@testable import ElecCalc

final class CableAmpacityEngineTests: XCTestCase {

    // Referans: IEC 60364-5-52:2009 — air→Metod E (B.52.10-13), conduit→B1 (B.52.4/5), underground→D1 (B.52.4/5)

    func testBaseAmpacity_copper_xlpe_air_10mm() {
        // 10mm² bakır XLPE havada (Metod E) → 75A (B.52.12)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 10, material: .copper, insulation: .xlpe, method: .air)
        XCTAssertEqual(result, 75.0)
    }

    func testBaseAmpacity_copper_pvc_air_10mm() {
        // 10mm² bakır PVC havada (Metod E) → 60A (B.52.10)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 10, material: .copper, insulation: .pvc, method: .air)
        XCTAssertEqual(result, 60.0)
    }

    func testBaseAmpacity_aluminum_pvc_conduit_16mm() {
        // 16mm² alüminyum PVC kanalda (B1) → 53A (B.52.4)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 16, material: .aluminum, insulation: .pvc, method: .conduit)
        XCTAssertEqual(result, 53.0)
    }

    func testBaseAmpacity_copper_pvc_conduit_150mm() {
        // 150mm² bakır PVC kanalda (B1) → 262A (B.52.4 — eski tabloda 267 idi)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 150, material: .copper, insulation: .pvc, method: .conduit)
        XCTAssertEqual(result, 262.0)
    }

    func testBaseAmpacity_copper_pvc_underground_16mm() {
        // 16mm² bakır PVC toprakta (D1) → 64A (B.52.4)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 16, material: .copper, insulation: .pvc, method: .underground)
        XCTAssertEqual(result, 64.0)
    }

    func testBaseAmpacity_aluminum_xlpe_underground_25mm() {
        // 25mm² alüminyum XLPE toprakta (D1) → 75A (B.52.5)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 25, material: .aluminum, insulation: .xlpe, method: .underground)
        XCTAssertEqual(result, 75.0)
    }

    func testBaseAmpacity_copper_xlpe_conduit_240mm() {
        // 240mm² bakır XLPE kanalda (B1) → 450A (B.52.5 — eski tabloda 470 idi)
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 240, material: .copper, insulation: .xlpe, method: .conduit)
        XCTAssertEqual(result, 450.0)
    }

    func testTemperatureFactor_pvc_30C() {
        // PVC, 30°C, havada → 1.0
        let kt = CableAmpacityEngine.temperatureFactor(insulation: .pvc, ambientTemp: 30, method: .air)
        XCTAssertEqual(kt, 1.0, accuracy: 1e-6)
    }

    func testTemperatureFactor_xlpe_40C() {
        // XLPE, 40°C, havada → 0.91
        let kt = CableAmpacityEngine.temperatureFactor(insulation: .xlpe, ambientTemp: 40, method: .air)
        XCTAssertEqual(kt, 0.91, accuracy: 1e-6)
    }

    func testGroupingFactor_1circuit() {
        let kg = CableAmpacityEngine.groupingFactor(circuitCount: 1)
        XCTAssertEqual(kg, 1.0)
    }

    func testGroupingFactor_3circuits() {
        let kg = CableAmpacityEngine.groupingFactor(circuitCount: 3)
        XCTAssertEqual(kg, 0.70, accuracy: 1e-6)
    }

    func testCorrectedAmpacity() {
        // 75A × 1.0 × 0.70 = 52.5A
        let result = CableAmpacityEngine.correctedAmpacity(base: 75, tempFactor: 1.0, groupFactor: 0.70)
        XCTAssertEqual(result, 52.5, accuracy: 1e-6)
    }

    func testFullCalculation_10mm_copper_xlpe_air_40C_3circuits() {
        // 10mm² bakır XLPE havada 40°C 3 devre
        guard let base = CableAmpacityEngine.baseAmpacity(crossSection: 10, material: .copper, insulation: .xlpe, method: .air) else {
            XCTFail("Base ampacity should exist")
            return
        }
        let kt = CableAmpacityEngine.temperatureFactor(insulation: .xlpe, ambientTemp: 40, method: .air)
        let kg = CableAmpacityEngine.groupingFactor(circuitCount: 3)
        let corrected = CableAmpacityEngine.correctedAmpacity(base: base, tempFactor: kt, groupFactor: kg)
        // 75 × 0.91 × 0.70 = 47.775
        XCTAssertEqual(corrected, 47.775, accuracy: 0.01)
    }
}
