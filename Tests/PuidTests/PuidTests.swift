//
//  PuidTests
//
//  MIT License: See project LICENSE.txt
//
//
import XCTest
@testable import Puid

final class PuidTests: XCTestCase {
  func round2(_ x: Double) -> Double {
    round(x * 100) / 100.0
  }
  
  func testAlpha() throws {
    let fixed = Puid.Entropy.Fixed(hex: "F1 B1 78 0A CE 2B")
    
    let alpha14Id = try Puid(bits: 14, chars: .alpha, entropy: fixed)
    XCTAssertEqual(try alpha14Id.generate(), "jYv")
    XCTAssertEqual(try alpha14Id.generate(), "AVn")
  }
  
  func testAlphaLower() throws {
    let fixed = Puid.Entropy.Fixed(hex: "F1 B1 78 0B AA 28")
    
    // shifts: [(25, 5), (27, 4), (31, 3)]
    //
    //    F    1    B    1    7    8    0    B    A    A
    // 1111 0001 1011 0001 0111 1000 0000 1011 1010 1010
    //
    // 111 10001 10110 00101 111 00000 00101 1101 01010
    // xxx |---| |---| |---| xxx |---| |---| xxxx |---|
    //  30   17    22     5   30    0     5    26   10
    //        r     w     f         a     f          k
    
    let alphaLower8Id = try Puid(bits: 8, chars: .alphaLower, entropy: fixed)
    XCTAssertEqual(try alphaLower8Id.generate(), "rw")
    XCTAssertEqual(try alphaLower8Id.generate(), "fa")
    XCTAssertEqual(try alphaLower8Id.generate(), "fk")

    fixed.reset()

    let alphaLower14Id = try Puid(bits: 14, chars: .alphaLower, entropy: fixed)
    XCTAssertEqual(try alphaLower14Id.generate(), "rwf")
    XCTAssertEqual(try alphaLower14Id.generate(), "afk")

    fixed.reset()

    let alphaLower20Id = try Puid(bits: 22, chars: .alphaLower, entropy: fixed)
    XCTAssertEqual(try alphaLower20Id.generate(), "rwfaf")
  }
  
  func testAlphaUpper() throws {
    let fixed = Puid.Entropy.Fixed(hex: "F1 B1 78 0A CE 28")
    
    let alphaUpper14Id = try Puid(bits: 14, chars: .alphaUpper, entropy: fixed)
    XCTAssertEqual(try alphaUpper14Id.generate(), "RWF")
    XCTAssertEqual(try alphaUpper14Id.generate(), "AFM")
  }
  
  func testAlphaNum() throws {
    let fixed = Puid.Entropy.Fixed(hex: "D2 E3 E9 FA 19 00")
    
    // shifts: [{61, 6}, {63, 5}]
    //
    //    D    2    E    3    E    9    F    A    1    9    0    0
    // 1101 0010 1110 0011 1110 1001 1111 1010 0001 1001 0000 0000
    //
    // 110100 101110 001111 101001 11111 010000 110010 000000 0
    // |----| |----| |----| |----| xxxxx |----| |----| |----|
    //   52     46     15     41     62     16     50      0
    //    0      u      P      p             Q      y      A
    //
    
    let alphaNum12 = try Puid(bits: 12, chars: .alphaNum, entropy: fixed)
    XCTAssertEqual(try alphaNum12.generate(), "0uP")
    XCTAssertEqual(try alphaNum12.generate(), "pQy")
    
    fixed.reset()
    
    let alphaNum41 = try Puid(bits: 41, chars: .alphaNum, entropy: fixed)
    XCTAssertEqual(try alphaNum41.generate(), "0uPpQyA")
  }

  func testAlphaNumLower() throws {
    let fixed = Puid.Entropy.Fixed(hex: "D2 E3 E9 Fa 19 00 C8 2D")
    
    let alphaNumLower12 = try Puid(bits: 12, chars: .alphaNumLower, entropy: fixed)
    XCTAssertEqual(try alphaNumLower12.generate(), "s9p")
    XCTAssertEqual(try alphaNumLower12.generate(), "qib")
  }

  func testAlphaNumUpper() throws {
    let fixed = Puid.Entropy.Fixed(hex: "D2 E3 E9 Fa 19 00 C8 2D")
    
    let alphaNumUpper26 = try Puid(bits: 26, chars: .alphaNumUpper, entropy: fixed)
    XCTAssertEqual(try alphaNumUpper26.generate(), "S9PQIB")
  }
  
  func testBase32() throws {
    let fixed = Puid.Entropy.Fixed(hex: "D2 E3 E9 DA 19 00 22")
    
    let base32_46Id = try Puid(bits: 46, chars: .base32, entropy: fixed)
    XCTAssertEqual(try base32_46Id.generate(), "2LR6TWQZAA")
  }

  func testBase32Hex() throws {
    let fixed = Puid.Entropy.Fixed(hex: "d2 e3 e9 da 19 03 b7 3c")
    
    let base30Hex33Id = try Puid(bits: 30, chars: .base32Hex, entropy: fixed)
    XCTAssertEqual(try base30Hex33Id.generate(), "qbhujm")
    XCTAssertEqual(try base30Hex33Id.generate(), "gp0erj")
  }
  
  func testBase32HexUpper() throws {
    let fixed = Puid.Entropy.Fixed(hex: "d2 e3 e9 da 19 03 b7 3c")
    
    let base30HexUpper14Id = try Puid(bits: 14, chars: .base32HexUpper, entropy: fixed)
    XCTAssertEqual(try base30HexUpper14Id.generate(), "QBH")
    XCTAssertEqual(try base30HexUpper14Id.generate(), "UJM")
    XCTAssertEqual(try base30HexUpper14Id.generate(), "GP0")
    XCTAssertEqual(try base30HexUpper14Id.generate(), "ERJ")
  }
  
  func testCrockford32() throws {
    let fixed = Puid.Entropy.Fixed(hex: "d2 e3 e9 da 19 03 b7 3c 00")
    
    let crockford32Id = try Puid(bits: 20, chars: .crockford32, entropy: fixed)
    XCTAssertEqual(try crockford32Id.generate(), "TBHY")
    XCTAssertEqual(try crockford32Id.generate(), "KPGS")
    XCTAssertEqual(try crockford32Id.generate(), "0EVK")
  }

  func testDecimal() throws {
    let fixed = Puid.Entropy.Fixed(hex: "d2 e3 e9 da 19 03 b7 3c ff")
    
    // shifts: [(9, 4), (11, 3), (15, 2)]
    //
    //    D    2    E    3    E    9    D    A    1    9    0    3    B    7    3    C    F    F
    // 1101 0010 1110 0011 1110 1001 1101 1010 0001 1001 0000 0011 1011 0111 0011 1100 1111 1111
    //
    // 11 0100 101 11 0001 11 11 0100 11 101 101 0000 11 0010 0000 0111 0110 11 1001 11 1001 111 1111
    // xx |--| xxx xx |--| xx xx |--| xx xxx xxx |--| xx |--| |--| |--| |--| xx |--| xx |--|
    // 13   4   11 12   1  15 13   4  14  11  10   0  12   2    0    7    6  14   9  14   9
    //      4           1          4               0       2    0    7    6       9       9
    
    let decimal16Id = try Puid(bits: 16, chars: .decimal, entropy: fixed)
    XCTAssertEqual(try decimal16Id.generate(), "41402")
    XCTAssertEqual(try decimal16Id.generate(), "07699")
  }

  func testHex() throws {
    let fixed = Puid.Entropy.Fixed(hex: "C7 C9 00 2A")
    
    let hex8Id = try Puid(bits: 8, chars: .hex, entropy: fixed)
    XCTAssertEqual(try hex8Id.generate(), "c7")
    XCTAssertEqual(try hex8Id.generate(), "c9")
    XCTAssertEqual(try hex8Id.generate(), "00")
    XCTAssertEqual(try hex8Id.generate(), "2a")
    
    fixed.reset()
    
    let hex12Id = try Puid(bits: 12, chars: .hex, entropy: fixed)
    XCTAssertEqual(try hex12Id.generate(), "c7c")
    XCTAssertEqual(try hex12Id.generate(), "900")

    fixed.reset()
    let hex32Id = try Puid(bits: 32, chars: .hex, entropy: fixed)
    XCTAssertEqual(try hex32Id.generate(), "c7c9002a")
  }
    
  func testHexUpper() throws {
    let fixed = Puid.Entropy.Fixed(hex: "c7 c9 00 2a 16 32")
    
    let hexUpper16Id = try Puid(bits: 12, chars: .hexUpper, entropy: fixed)
    XCTAssertEqual(try hexUpper16Id.generate(), "C7C")
    XCTAssertEqual(try hexUpper16Id.generate(), "900")
    XCTAssertEqual(try hexUpper16Id.generate(), "2A1")
    XCTAssertEqual(try hexUpper16Id.generate(), "632")
  }
  
  func testSafeAscii() throws {
    let fixed = Puid.Entropy.Fixed(hex: "A6 33 2A BE E6 2D B3 68 41")
    
    // shifts: [(89, 7), (91, 6), (95, 5), (127, 2)]
    //
    //    A    6    3    3   2    A    B    E    E    6    2    D    B    3    6    8
    // 1010 0110 0011 0011 0010 1010 1011 1110 1110 0110 0010 1101 1011 0011 0110 1000 0100 0001
    //
    // 1010011 0001100  11 0010010 0101111 10111 0011000 101101 1011001 101101 0000100 0001
    // |-----| |-----|  xx |-----| |-----| xxxxx |-----| xxxxxx |-----| xxxxxx |-----|
    //    83      12   101    21      47     92     24      91     89      90      4
    //     x       /           8       R             ;              ~              &

    let safeAscii12Id = try Puid(bits: 18, chars: .safeAscii, entropy: fixed)
    XCTAssertEqual(try safeAscii12Id.generate(), "x/8")
    XCTAssertEqual(try safeAscii12Id.generate(), "R;~")
  }
  
  func testSafe32() throws {
    let fixed = Puid.Entropy.Fixed(hex: "d2 e3 e9 da 19 03 b7 3c")
    
    //    D    2    E    3    E    9    D    A    1    9    0    3    B    7    3    C
    // 1101 0010 1110 0011 1110 1001 1101 1010 0001 1001 0000 0011 1011 0111 0011 1100
    //
    // 11010 01011 10001 11110 10011 10110 10000 11001 00000 01110 11011 10011 1100
    // |---| |---| |---| |---| |---| |---| |---| |---| |---| |---| |---| |---|
    //   26    11    17    30    19    22    16    25     0    14    27    19
    //   M     h     r     R     B     G     q     L     2     n     N     B

    let safe32_7Id = try Puid(bits: 7, chars: .safe32, entropy: fixed)
    XCTAssertEqual(try safe32_7Id.generate(), "Mh")
    XCTAssertEqual(try safe32_7Id.generate(), "rR")
    XCTAssertEqual(try safe32_7Id.generate(), "BG")
    XCTAssertEqual(try safe32_7Id.generate(), "qL")
    XCTAssertEqual(try safe32_7Id.generate(), "2n")
    XCTAssertEqual(try safe32_7Id.generate(), "NB")
    
    fixed.reset()
    
    let safe32_21Id = try Puid(bits: 21, chars: .safe32, entropy: fixed)
    XCTAssertEqual(try safe32_21Id.generate(), "MhrRB")
    XCTAssertEqual(try safe32_21Id.generate(), "GqL2n")
    
    fixed.reset()
    
    let safe32_58Id = try Puid(bits: 58, chars: .safe32, entropy: fixed)
    XCTAssertEqual(try safe32_58Id.generate(), "MhrRBGqL2nNB")
  }
  
  func testSafe64() throws {
    let fixed = Puid.Entropy.Fixed(hex: "D2 E3 E9 FA 19 00")
    
    let puid25 = try Puid(bits: 25, entropy: fixed)
    XCTAssertEqual(try puid25.generate(), "0uPp-")
    
    fixed.reset()
    
    let puid48 = try Puid(bits: 48, entropy: fixed)
    XCTAssertEqual(try puid48.generate(), "0uPp-hkA")
  }
  
  func testDingosky() throws {
    let fixed = Puid.Entropy.Fixed(hex: "C7 C9 00 2A BD 72")
    
    let dingoskyId = try Puid(bits: 24, chars: .custom("dingosky"), entropy: fixed)
    XCTAssertEqual(try dingoskyId.generate(), "kiyooodd")
    XCTAssertEqual(try dingoskyId.generate(), "insgkskn")
  }
  
  func testVowels() throws {
    let fixed = Puid.Entropy.Fixed(hex: "A6 33 F6 9E BD EE A7 00 00")

    // shifts: [(9, 4), (11, 3), (15, 2)]
    //
    //    A    6    3    3    F    6    9    E    B    D    E    E    A    7
    // 1010 0110 0011 0011 1111 0110 1001 1110 1011 1101 1110 1110 1010 0111
    //
    // 101 0011 0001 1001 11 11 101 101 0011 11 0101 11 101 11 101 11 0101 0011 1
    // xxx |--| |--| |--| xx xx xxx xxx |--| xx |--| xx xxx xx xxx xx |--| |--|
    //  10   3    1    9  15 14  11  10   3  13   5  14  11 14  11 13   5    3
    //       o    e    U                  o       A                     A    o
    
    let vowel3BitsId = try Puid(bits: 3, chars: .custom("aeiouAEIOU"), entropy: fixed)
    XCTAssertEqual(try vowel3BitsId.generate(), "o")
    XCTAssertEqual(try vowel3BitsId.generate(), "e")
    XCTAssertEqual(try vowel3BitsId.generate(), "U")
    XCTAssertEqual(try vowel3BitsId.generate(), "o")
    XCTAssertEqual(try vowel3BitsId.generate(), "A")
    XCTAssertEqual(try vowel3BitsId.generate(), "A")
    XCTAssertEqual(try vowel3BitsId.generate(), "o")

    fixed.reset()
    let vowel14BitsId = try Puid(bits: 14, chars: .custom("aeiouAEIOU"), entropy: fixed)
    XCTAssertEqual(try vowel14BitsId.generate(), "oeUoA")

    fixed.reset()
    let vowel20BitsId = try Puid(bits: 20, chars: .custom("aeiouAEIOU"), entropy: fixed)
    XCTAssertEqual(try vowel20BitsId.generate(), "oeUoAAo")
  }
  
  func testDîngøsky() throws {
    let fixed = Puid.Entropy.Fixed(hex: "C7 C9 00 2A BD 72")
    
    let dingoskyId = try Puid(bits: 24, chars: .custom("dîngøsky"), entropy: fixed)
    XCTAssertEqual(try dingoskyId.generate(), "kîyøøødd")
    XCTAssertEqual(try dingoskyId.generate(), "însgkskn")
  }

  func testDîngøskyDog() throws {
    let fixed = Puid.Entropy.Fixed(hex: "ec f9 db 7a 33 3d 21 97 a0 c2 bf 92 80 dd 2f 57 12 c1 1a ef")
    
    let dogId = try Puid(bits: 24, chars: .custom("dîngøsky:🐕"), entropy: fixed)
    XCTAssertEqual(try dogId.generate(), "🐕gî🐕🐕nî🐕")
    XCTAssertEqual(try dogId.generate(), "ydkîsnsd")
    XCTAssertEqual(try dogId.generate(), "îøsîndøk")
  }

  func test256Chars() throws {
    let fixed = Puid.Entropy.Fixed(hex: "ec f9 db 7a 33 3d 21 97 a0 c2 bf 92 80 dd 2f 57 12 c1 1a ef")
    
    let codePoints: [UInt32] =
    [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
     85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
     108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48,
     49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 95, 256, 257, 258, 259, 260, 261, 262,
     263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278,
     279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294,
     295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310,
     311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326,
     327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342,
     343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358,
     359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374,
     375, 376, 377, 378, 379, 380, 381, 382, 383, 19904, 19905, 19906, 19907, 19908,
     19909, 19910, 19911, 19912, 19913, 19914, 19915, 19916, 19917, 19918, 19919,
     19920, 19921, 19922, 19923, 19924, 19925, 19926, 19927, 19928, 19929, 19930,
     19931, 19932, 19933, 19934, 19935, 19936, 19937, 19938, 19939, 19940, 19941,
     19942, 19943, 19944, 19945, 19946, 19947, 19948, 19949, 19950, 19951, 19952,
     19953, 19954, 19955, 19956, 19957, 19958, 19959, 19960, 19961, 19962, 19963,
     19964, 19965, 19966, 19967]
    
    let utf8Codes = codePoints.map { UnicodeScalar($0)! }
    let chars = Puid.Chars.custom(utf8Codes.string)
    
    let id = try Puid(bits: 36, chars: chars, entropy: fixed)
    
    XCTAssertEqual(id.settings.length, 5)
    XCTAssertEqual(id.settings.bitsPerChar, 8.0)
    XCTAssertEqual(id.settings.ere, 0.5)
    
    
    XCTAssertEqual(try id.generate(), "䷬䷹䷛ĺz")
    XCTAssertEqual(try id.generate(), "9hŗŠ䷂")
    XCTAssertEqual(try id.generate(), "ſŒŀ䷝v")
    XCTAssertEqual(try id.generate(), "ėS䷁a䷯")
  }
  
  func testPuidProperties() throws {
    let puid = try Puid(bits: 96, chars: .alphaNumUpper)
    
    XCTAssertEqual(round2(puid.bits), 98.23)
    XCTAssertEqual(round2(puid.bitsPerChar), 5.17)
    XCTAssertEqual(puid.chars, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    XCTAssertEqual(puid.source, "SecRandomCopyBytes")
    XCTAssertEqual(round2(puid.ere), 0.65)
    XCTAssertEqual(puid.length, 19)
  }
  
  func testRiskAfter() throws {
    let total = 1e6
    let risk = 1e6
    
    let puid = try Puid(total: total, risk: risk)
    
    XCTAssertTrue(risk < puid.risk(after: total))
  }
}
