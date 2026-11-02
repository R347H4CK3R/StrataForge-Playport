// SPDX-License-Identifier: GPL-3.0-or-later
import XCTest
@testable import PlayportKit

final class StrataForgeRecoveryTests: XCTestCase {
    func testClassification() {
        XCTAssertEqual(StrataForgeRecovery(message: "JIT debugger detached"), .jit)
        XCTAssertEqual(StrataForgeRecovery(message: "Jetsam allocation failed"), .memory)
        XCTAssertEqual(StrataForgeRecovery(message: "DXMT shader compilation failed"), .graphics)
        XCTAssertEqual(StrataForgeRecovery(message: "Steam depot missing"), .steam)
        XCTAssertEqual(StrataForgeRecovery(message: "wineserver socket error"), .wine)
        XCTAssertEqual(StrataForgeRecovery(message: "Unclassified failure"), .unknown)
    }
    func testGuidanceNeverPromisesAutomaticRepair() {
        for sample in ["jit", "jetsam", "DXMT", "Steam", "wineserver", "other"] {
            let guidance = StrataForgeRecovery(message: sample).guidance
            XCTAssertFalse(guidance.isEmpty)
            XCTAssertFalse(guidance.contains("automatically repaired"))
        }
    }
}
