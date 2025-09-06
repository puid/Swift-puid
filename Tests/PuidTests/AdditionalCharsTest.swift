//
//  AdditionalCharsTest
//
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class AdditionalCharsTest: XCTestCase {
  private func isAsciiSubset(_ chars: Puid.Chars, of set: CharacterSet) -> Bool {
    let isSubset = CharacterSet(charactersIn: chars.string).isSubset(of: set)
    return isSubset && chars.string.reduce(true) { valid, char in
      return valid && char.isASCII
    }
  }

  func testNewCounts() {
    XCTAssertEqual(Puid.Chars.base16.count, 16)
    XCTAssertEqual(Puid.Chars.base36.count, 36)
    XCTAssertEqual(Puid.Chars.base36Upper.count, 36)
    XCTAssertEqual(Puid.Chars.base58.count, 58)
    XCTAssertEqual(Puid.Chars.base62.count, 62)
    XCTAssertEqual(Puid.Chars.bech32.count, 32)
    XCTAssertEqual(Puid.Chars.boolean.count, 2)
    XCTAssertEqual(Puid.Chars.dna.count, 4)
    XCTAssertEqual(Puid.Chars.geohash.count, 32)
    XCTAssertEqual(Puid.Chars.urlSafe.count, 66)
    XCTAssertEqual(Puid.Chars.wordSafe32.count, 32)
    XCTAssertEqual(Puid.Chars.zBase32.count, 32)
  }

  func testNewContents() {
    XCTAssert(isAsciiSubset(.base16, of: .decimalDigits.union(CharacterSet(charactersIn: "ABCDEF"))))
    XCTAssert(isAsciiSubset(.base36, of: .decimalDigits.union(.lowercaseLetters)))
    XCTAssert(isAsciiSubset(.base36Upper, of: .decimalDigits.union(.uppercaseLetters)))

    let base58Removed = CharacterSet(charactersIn: "0OlI")
    XCTAssert(isAsciiSubset(.base58, of: .alphanumerics.subtracting(base58Removed)))

    XCTAssert(isAsciiSubset(.base62, of: .alphanumerics))

    let bech32Removed = CharacterSet(charactersIn: "1bio")
    XCTAssert(isAsciiSubset(.bech32, of: .decimalDigits.union(.lowercaseLetters).subtracting(bech32Removed)))

    XCTAssert(isAsciiSubset(.boolean, of: CharacterSet(charactersIn: "TF")))
    XCTAssert(isAsciiSubset(.dna, of: CharacterSet(charactersIn: "ACGT")))

    let geohashRemoved = CharacterSet(charactersIn: "ailo")
    XCTAssert(isAsciiSubset(.geohash, of: .decimalDigits.union(.lowercaseLetters).subtracting(geohashRemoved)))

    XCTAssert(isAsciiSubset(.urlSafe, of: .alphanumerics.union(CharacterSet(charactersIn: "-._~"))))

    // wordSafe32: ensure only alphanumerics
    XCTAssert(isAsciiSubset(.wordSafe32, of: .alphanumerics))

    // zBase32: lowercase letters and digits
    XCTAssert(isAsciiSubset(.zBase32, of: .lowercaseLetters.union(.decimalDigits)))
  }
}

