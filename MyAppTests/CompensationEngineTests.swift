import XCTest
@testable import ElecCalc

final class CompensationEngineTests: XCTestCase {

    func testRequiredReactivePower() {
        // Qc = P × (tanφ₁ - tanφ₂), cosφ₁=0.7 → tanφ₁=1.0202, cosφ₂=0.95 → tanφ₂=0.3287
        // Qc = 100 × 0.69152 = 69.152 kVAR
        let result = CompensationEngine.requiredReactivePower(
            activePower: 100, currentCosPhi: 0.7, targetCosPhi: 0.95
        )
        XCTAssertEqual(result, 69.152, accuracy: 1e-2)
    }

    func testRecommendedCapacitor() {
        // 42 kVAR → en yakın 50
        XCTAssertEqual(CompensationEngine.recommendedCapacitor(requiredKVAR: 42.0), 50.0)
        // 5 kVAR → 5
        XCTAssertEqual(CompensationEngine.recommendedCapacitor(requiredKVAR: 5.0), 5.0)
        // 300 kVAR → 300
        XCTAssertEqual(CompensationEngine.recommendedCapacitor(requiredKVAR: 300.0), 300.0)
        // 301 → nil
        XCTAssertNil(CompensationEngine.recommendedCapacitor(requiredKVAR: 301.0))
    }

    func testNewCosPhi() {
        // cosφ₁=0.7, P=100, 75 kVAR kuruldu → yeni cosφ > 0.95
        let result = CompensationEngine.newCosPhi(activePower: 100, currentCosPhi: 0.7, installedKVAR: 75)
        XCTAssertGreaterThan(result, 0.9)
        XCTAssertLessThanOrEqual(result, 1.0)
    }

    func testNewCosPhi_exactCalculation() {
        // P=100, cosφ₁=0.8 → Q₁=75, kVAR=30 → newQ=45
        // S=√(100²+45²)=109.6586 → newCosφ = 100/109.6586 = 0.91192
        let result = CompensationEngine.newCosPhi(activePower: 100, currentCosPhi: 0.8, installedKVAR: 30)
        XCTAssertEqual(result, 0.91192, accuracy: 1e-4)
    }
}
