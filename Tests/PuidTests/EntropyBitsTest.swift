//
//  EntropyBitsTest
//  
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class EntropyBitsTest: XCTestCase {
  
  func testZeroBits() throws {
    XCTAssertEqual(Puid.Entropy.bits(total: 0, risk: 0), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 0, risk: 100), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 0, risk: 1e12), 0.0)
    
    XCTAssertEqual(Puid.Entropy.bits(total: 100, risk: 0), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 100_000, risk: 0), 0.0)

    XCTAssertEqual(Puid.Entropy.bits(total: 1, risk: 0), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 1, risk: 100), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 1, risk: 1e12), 0.0)
    
    XCTAssertEqual(Puid.Entropy.bits(total: 100, risk: 1), 0.0)
    XCTAssertEqual(Puid.Entropy.bits(total: 100_000, risk: 1), 0.0)
  }

  func round2(_ x: Double) -> Double {
    round(x * 100) / 100.0
  }
  
  func assertTotalRisk(_ total: Double, _ risk: Double, _ bits: Double) {
    XCTAssertEqual(round2(Puid.Entropy.bits(total: total, risk: risk)), bits)
  }
  
  func testTotalRisk() throws {
    assertTotalRisk(100, 100, 18.92)
    assertTotalRisk(100, 100, 18.92)
    assertTotalRisk(999, 1000, 28.89)
    assertTotalRisk(1000, 1000, 28.9)
    assertTotalRisk(10000, 1000, 35.54)
    assertTotalRisk(100_000, 1e12, 72.08)
    assertTotalRisk(1e10, 1e21, 135.2)
  }
  
  func testRiskAfter() throws {
    let birthdays = 365.0
    let people = 23.0
    let risk = 0.5
    
    XCTAssertEqual(round2(Puid.Entropy.risk(total: people, bits: log2(birthdays))), risk)
  }
  
}
