//
//  CharsTest
//
//  MIT License: See project LICENSE.txt
//

import XCTest

@testable import Puid

final class CharsTest: XCTestCase {
  func bitShift(_ value: Int, _ shift: Int) -> Puid.Bits.Shift {
    Puid.Bits.Shift(value: value, shift: shift)
  }

  func round2(_ x: Double) -> Double {
    round(x * 100) / 100.0
  }

  func assertBitsPerChar(_ chars: Puid.Chars, _ bpc: Double) {
    XCTAssertEqual(round2(chars.bitsPerChar), bpc)
  }

  func assertBitsPerChar(_ string: String, _ bpc: Double) {
    assertBitsPerChar(Puid.Chars.custom(string), bpc)
  }

  func testBitsPerChar() throws {
    assertBitsPerChar("dingosky", 3.0)
    assertBitsPerChar("dingosky:!", 3.32)
    assertBitsPerChar("dîngøsky:\u{1F415}", 3.32)
  }

  func assertBitShifts(for chars: Puid.Chars, _ expect: [Puid.Bits.Shift]) {
    XCTAssert(chars.bitShifts.elementsEqual(expect, by: ==))
  }

  func assertBitShifts(for string: String, _ expect: [Puid.Bits.Shift]) {
    assertBitShifts(for: Puid.Chars.custom(string), expect)
  }

  func testCustomCharsBitShifts() throws {
    assertBitShifts(for: "dingosky", [bitShift(7, 3)])
    assertBitShifts(for: "dîngøsky", [bitShift(7, 3)])
    assertBitShifts(for: "aeiouAEIOU", [bitShift(9, 4), bitShift(11, 3), bitShift(15, 2)])
  }

  func testCharsBitShifts() throws {
    assertBitShifts(for: .alpha, [bitShift(51, 6), bitShift(55, 4), bitShift(63, 3)])
    assertBitShifts(for: .alphaLower, [bitShift(25, 5), bitShift(27, 4), bitShift(31, 3)])
    assertBitShifts(for: .alphaNum, [bitShift(61, 6), bitShift(63, 5)])
    assertBitShifts(for: .alphaNumLower, [bitShift(35, 6), bitShift(39, 4), bitShift(47, 3), bitShift(63, 2)])
    assertBitShifts(for: .hex, [bitShift(15, 4)])
    assertBitShifts(for: .safeAscii, [bitShift(89, 7), bitShift(91, 6), bitShift(95, 5), bitShift(127, 2)])
    assertBitShifts(for: .safe32, [bitShift(31, 5)])
  }

  func assertCount(_ chars: Puid.Chars, _ count: Int) {
    XCTAssertEqual(chars.count, count)
  }

  func testCounts() throws {
    assertCount(.alpha, 52)
    assertCount(.alphaLower, 26)
    assertCount(.alphaUpper, 26)
    assertCount(.alphaNumLower, 36)
    assertCount(.alphaNumUpper, 36)
    assertCount(.base32, 32)
    assertCount(.base32Hex, 32)
    assertCount(.base32HexUpper, 32)
    assertCount(.decimal, 10)
    assertCount(.hex, 16)
    assertCount(.hexUpper, 16)
    assertCount(.safeAscii, 90)
    assertCount(.safe32, 32)
    assertCount(.safe64, 64)
    assertCount(.symbol, 28)
  }

  private func isAsciiSubset(_ chars: Puid.Chars, of set: CharacterSet) -> Bool {
    let isSubset = CharacterSet(charactersIn: chars.string).isSubset(of: set)
    return isSubset
      && chars.string.reduce(true) { valid, char in
        return valid && char.isASCII
      }
  }

  func testContents() throws {
    XCTAssert(isAsciiSubset(.alpha, of: .letters))
    XCTAssert(isAsciiSubset(.alphaLower, of: .lowercaseLetters))
    XCTAssert(isAsciiSubset(.alphaUpper, of: .uppercaseLetters))
    XCTAssert(isAsciiSubset(.alphaNum, of: .alphanumerics))
    XCTAssert(isAsciiSubset(.alphaNumLower, of: .alphanumerics.subtracting(.uppercaseLetters)))
    XCTAssert(isAsciiSubset(.alphaNumUpper, of: .alphanumerics.subtracting(.lowercaseLetters)))
    XCTAssert(
      isAsciiSubset(
        .base32, of: .uppercaseLetters.union(.decimalDigits).subtracting(CharacterSet(charactersIn: "0189"))))
    XCTAssert(
      isAsciiSubset(
        .base32Hex, of: .decimalDigits.union(.lowercaseLetters).subtracting(CharacterSet(charactersIn: "wxyz"))))
    XCTAssert(
      isAsciiSubset(
        .base32HexUpper, of: .decimalDigits.union(.uppercaseLetters).subtracting(CharacterSet(charactersIn: "WXYZ"))))
    XCTAssert(
      isAsciiSubset(
        .crockford32, of: .decimalDigits.union(.uppercaseLetters).subtracting(CharacterSet(charactersIn: "ILOU"))))
    XCTAssert(isAsciiSubset(.decimal, of: .decimalDigits))
    XCTAssert(isAsciiSubset(.hex, of: .decimalDigits.union(CharacterSet(charactersIn: "abcdef"))))
    XCTAssert(isAsciiSubset(.hexUpper, of: .decimalDigits.union(CharacterSet(charactersIn: "ABCDEF"))))

    let symbols = CharacterSet(charactersIn: "!#$%&()*+,-./:;<=>?@[]^_{|}~")
    XCTAssert(isAsciiSubset(.safeAscii, of: .alphanumerics.union(symbols)))

    let removed = CharacterSet(charactersIn: "015aceiouyAEIOUYcklvwxzCIKSVWXZ")
    XCTAssert(isAsciiSubset(Puid.Chars.safe32, of: .alphanumerics.subtracting(removed)))

    XCTAssert(isAsciiSubset(Puid.Chars.safe64, of: .alphanumerics.union(CharacterSet(charactersIn: "-_"))))

    // CxTBD symbols
  }

}
