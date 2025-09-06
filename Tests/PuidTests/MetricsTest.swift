//
//  MetricsTest
//
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class MetricsTest: XCTestCase {
  func round(_ x: Double, places: Int) -> Double {
    let p = pow(10.0, Double(places))
    return Darwin.round(x * p) / p
  }

  func testSafe64Metrics() {
    let m = Puid.Chars.metrics(.safe64)
    XCTAssertEqual(m.bitShifts.count, 1)
    XCTAssertEqual(m.bitShifts[0].value, 63)
    XCTAssertEqual(m.bitShifts[0].shift, 6)

    XCTAssertEqual(m.avgBits, 6.0, accuracy: 1e-12)
    XCTAssertEqual(m.ere, 0.75, accuracy: 1e-12)
    XCTAssertEqual(m.ete, 1.0, accuracy: 1e-12)
  }

  func testAlphaMetrics() {
    let m = Puid.Chars.metrics(.alpha)
    XCTAssertEqual(m.bitShifts.map { $0.value }, [51, 55, 63])
    XCTAssertEqual(m.bitShifts.map { $0.shift }, [6, 4, 3])

    XCTAssertEqual(m.avgBits, 6.769230769230769, accuracy: 1e-12)
    XCTAssertEqual(m.ere, 0.7125549647676365, accuracy: 1e-12)
    XCTAssertEqual(m.ete, 0.8421104129072068, accuracy: 1e-12)
  }
}

