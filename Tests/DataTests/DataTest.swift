//
//  DataTest
//  
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class DataTest: XCTestCase {
  static func dataUrl(_ name: String) -> URL {
    URL(fileURLWithPath: #file.replacingOccurrences(of: "DataTests/DataTest.swift", with: "data/\(name)"))
  }
  
  func predefined(for predefined: String) -> Puid.Chars {
    if predefined == "alphanum" {
      return .alphaNum
    }
    if predefined == "safe32" {
      return .safe32
    }

    if predefined == "safe_ascii" {
      return .safeAscii
    }
    return Puid.Chars.custom("CxError")
  }
  
  func puid(from params: Params) throws -> Puid {
    let entropy = Puid.Entropy.Fixed(data: try Data(contentsOf: params.binUrl))
    
    let charsComponents = params.chars.components(separatedBy: ":")
    var chars: Puid.Chars
    if charsComponents[0] == "custom" {
      chars = Puid.Chars.custom(charsComponents[1])
    } else {
      chars = predefined(for: charsComponents[1])
    }
    
    return try Puid(total: params.total, risk: params.risk, chars: chars, entropy: entropy)
  }
  
  func ids(for name: String) throws -> [String] {
    var ids = try String(contentsOf: DataTest.dataUrl("\(name)/ids")).components(separatedBy: .newlines)
    // This ensure there will be enough fixed bytes to cover all the IDs
    ids.removeLast()
    ids.removeLast()
    return ids
  }

  func assertPuids(for name: String) throws {
    let params = try Params(for: name)
    let puid = try puid(from: params)
    let ids = try ids(for: name)

    for id in ids {
      XCTAssertEqual(id, try puid.generate())
    }
  }

  func testAlpha10Lower() throws {
    try assertPuids(for: "alpha_10_lower")
  }
  
  func testAlphanum() throws {
    try assertPuids(for: "alphanum")
  }

  func testDingosky() throws {
    try assertPuids(for: "dingosky")
  }
  
  func testSafe32() throws {
    try assertPuids(for: "safe32")
  }
  
  func testSafeAscii() throws {
    try assertPuids(for: "safe_ascii")
  }

  func testUnicode() throws {
    try assertPuids(for: "unicode")
  }
  
  struct Params {
    let binUrl: URL
    let name: String
    let total: Double
    let risk: Double
    let chars: String
    let count: Int
    
    init(for dataName: String) throws {
      let paramsUrl = DataTest.dataUrl("\(dataName)/params")
      let contents = try String(contentsOf: paramsUrl, encoding: .utf8).components(separatedBy: "\n")

      binUrl = DataTest.dataUrl(contents[0])
      name = contents[1]
      total = Double(contents[2])!
      risk = Double(contents[3])!
      chars = contents[4]
            count = Int(contents[5])!
    }
  }

  func testCoverage() throws {
    let _ = predefined(for: "invalid")
  }
}
