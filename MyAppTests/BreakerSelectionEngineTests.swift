import XCTest
@testable import ElecCalc

final class BreakerSelectionEngineTests: XCTestCase {

    func testLoadCurrent_threePhase() {
        // Ib = P(kW)×1000 / (√3 × U × cosφ) = 30×1000 / (√3 × 400 × 0.85)
        let expected = 30.0 * 1000.0 / (sqrt(3.0) * 400.0 * 0.85)
        let result = BreakerSelectionEngine.loadCurrent(powerKW: 30, voltage: 400, cosPhi: 0.85, isThreePhase: true)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testLoadCurrent_singlePhase() {
        // Ib = P(kW)×1000 / (U × cosφ) = 5×1000 / (230 × 0.9)
        let expected = 5.0 * 1000.0 / (230.0 * 0.9)
        let result = BreakerSelectionEngine.loadCurrent(powerKW: 5, voltage: 230, cosPhi: 0.9, isThreePhase: false)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testRecommendedMCB_45A() {
        // 45A → ilk MCB ≥ 45 = 50A
        let mcb = BreakerSelectionEngine.recommendedMCB(loadCurrent: 45)
        XCTAssertEqual(mcb, 50)
    }

    func testRecommendedMCB_exceeds() {
        // 70A → MCB max 63A, nil döner
        let mcb = BreakerSelectionEngine.recommendedMCB(loadCurrent: 70)
        XCTAssertNil(mcb)
    }

    func testRecommendedMCCB_45A() {
        // 45A → ilk MCCB ≥ 45 = 50A
        let mccb = BreakerSelectionEngine.recommendedMCCB(loadCurrent: 45)
        XCTAssertEqual(mccb, 50)
    }

    func testRecommendedMCCB_500A() {
        // 500A → MCCB 500A
        let mccb = BreakerSelectionEngine.recommendedMCCB(loadCurrent: 500)
        XCTAssertEqual(mccb, 500)
    }

    func testRecommendedFuse_45A() {
        // 45A → ilk sigorta ≥ 45 = 50A
        let fuse = BreakerSelectionEngine.recommendedFuse(loadCurrent: 45)
        XCTAssertEqual(fuse, 50)
    }

    func testProtection_ok() {
        // Ib=45, In=50, Iz=57 → 45 ≤ 50 ≤ 57 → true
        XCTAssertTrue(BreakerSelectionEngine.checkProtection(loadCurrent: 45, breakerRating: 50, cableAmpacity: 57))
    }

    func testProtection_fail_breaker_exceeds_cable() {
        // Ib=45, In=63, Iz=57 → 63 > 57 → false
        XCTAssertFalse(BreakerSelectionEngine.checkProtection(loadCurrent: 45, breakerRating: 63, cableAmpacity: 57))
    }
}
