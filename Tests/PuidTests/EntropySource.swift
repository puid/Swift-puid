//
//  EntropyGenerator.swift
//  
//  MIT License: See project LICENSE.txt
//

import XCTest
import Puid

final class EntropySource: XCTestCase {
  
  struct Fixed: RandomNumberGenerator {
    let entries: [UInt64]
    
    var ndx = -1
    
    init(_ entries: [UInt64]) {
      self.entries = entries
    }
    
    mutating func next() -> UInt64 {
      ndx += 1
      return entries[ndx % entries.count]
    }
    
    static let method = "Fixed UInt64 values"
  }
  
  func test4bits() throws {
    // 8217508000407054677:  55 69 31 f7 fc 73 0a 72
    // 9004388400143975378:  d2 c3 3a ea 8a 03 f6 7c
    // 1369912841189526514:  f2 0b 59 90 78 e8 02 13
    // 14770944148999504823: b7 03 40 96 71 ef fc cc
    let fixedSource = Fixed([8217508000407054677, 9004388400143975378,
                             1369912841189526514, 14770944148999504823])
    let entropySource = Puid.Entropy.Source(using: fixedSource,
                                               method: Fixed.method)
    
    let puid = try Puid(bits: 24, chars: .hex, entropy: entropySource)
    
    XCTAssertEqual(try puid.generate(), "556931")
    XCTAssertEqual(try puid.generate(), "f7fc73")
    XCTAssertEqual(try puid.generate(), "0a72d2")
    XCTAssertEqual(try puid.generate(), "c33aea")
    XCTAssertEqual(try puid.generate(), "8a03f6")
    XCTAssertEqual(try puid.generate(), "7cf20b")
    XCTAssertEqual(try puid.generate(), "599078")
    XCTAssertEqual(try puid.generate(), "e80213")
    XCTAssertEqual(try puid.generate(), "b70340")
    XCTAssertEqual(try puid.generate(), "9671ef")
    XCTAssertEqual(try puid.generate(), "fccc55")
  }
  
  func test6bits() throws {
    // 8217508000407054677:  55 69 31 f7 fc 73 0a 72
    // 9004388400143975378:  d2 c3 3a ea 8a 03 f6 7c
    // 1369912841189526514:  f2 0b 59 90 78 e8 02 13
    // 14770944148999504823: b7 03 40 96 71 ef fc cc
    let fixedSource = Fixed([8217508000407054677, 9004388400143975378,
                             1369912841189526514, 14770944148999504823])
    let generator = Puid.Entropy.Source(using: fixedSource,
                                           method: Fixed.method)
    
    let puid = try Puid(bits: 44, entropy: generator)
    
    XCTAssertEqual(try puid.generate(), "VWkx9_xz")
    XCTAssertEqual(try puid.generate(), "CnLSwzrq")
    XCTAssertEqual(try puid.generate(), "igP2fPIL")
    XCTAssertEqual(try puid.generate(), "WZB46AIT")
  }
}
