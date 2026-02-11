import XCTest
@testable import ElecCalc

final class CableAmpacityEngineTests: XCTestCase {

    func testBaseAmpacity_copper_xlpe_air_10mm() {
        // 10mm² bakır XLPE havada → 75A
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 10, material: .copper, insulation: .xlpe, method: .air)
        XCTAssertEqual(result, 75.0)
    }

    func testBaseAmpacity_aluminum_pvc_conduit_16mm() {
        // 16mm² alüminyum PVC kanalda → 53A
        let result = CableAmpacityEngine.baseAmpacity(crossSection: 16, material: .aluminum, insulation: .pvc, method: .conduit)
        XCTAssertEqual(result, 53.0)
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
