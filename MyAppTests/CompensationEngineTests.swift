import XCTest
@testable import MyApp

final class CompensationEngineTests: XCTestCase {

    func testRequiredReactivePower() {
        // Qc = P × (tanφ₁ - tanφ₂)
        // cosφ₁=0.7, cosφ₂=0.95
        let expected = 100.0 * (tan(acos(0.7)) - tan(acos(0.95)))
        let result = CompensationEngine.requiredReactivePower(
            activePower: 100, currentCosPhi: 0.7, targetCosPhi: 0.95
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
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
        // Doğrulama: P=100, cosφ₁=0.8, Q₁=P×tan(acos(0.8))=75, kVAR=30
        // newQ=75-30=45, S=√(100²+45²)=√(12025)=109.66
        // newCosφ=100/109.66=0.9119
        let p = 100.0
        let phi1 = acos(0.8)
        let q1 = p * tan(phi1)
        let newQ = q1 - 30.0
        let s = sqrt(p * p + newQ * newQ)
        let expected = p / s
        let result = CompensationEngine.newCosPhi(activePower: p, currentCosPhi: 0.8, installedKVAR: 30)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }
}
