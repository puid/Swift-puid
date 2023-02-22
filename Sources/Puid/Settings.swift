//
//  Puid.Settings
//
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid {
  struct Settings {
    let bits: Double
    let bitsPerChar: Double
    let bitShifts: [Puid.Bits.Shift]
    let chars: Chars
    let ere: Double
    let entropy: PuidEntropySource
    let length: Int
    let nBytesPerPuid: Int
    
    init(bits: Double, chars: Puid.Chars, entropy: PuidEntropySource) throws {
      let (bits, bitsPerChar, nBytesPerPuid, ere, length) = Settings.puidInfo(for: chars,
                                                                              with: bits)

      self.bits = bits
      self.bitsPerChar = bitsPerChar
      bitShifts = chars.bitShifts
      self.entropy = entropy
      self.nBytesPerPuid = nBytesPerPuid
      self.chars = chars
      self.ere = ere
      self.length = length
    }
  }
}

/// Description
//extension Puid.Settings: CustomStringConvertible, CustomDebugStringConvertible {
//  func round2(_ x: Double) -> Double {
//    round(x * 100) / 100.0
//  }
//  
//  var description: String {
//    let charsName = Puid.Chars.allCases.contains(chars) ? "\(chars)" : "custom"
//    return
//"""
//  bits: \(round2(bits))
//  bitsPerChar: \(round2(bitsPerChar))
//  chars: \(charsName) "\(chars.string)"
//  ere: \(round2(ere))
//  length: \(length)
//"""
//  }
//  
//  var debugDescription: String {
//    let descr = self.description
//    return
//"""
//\(descr)
//  bitShifts: \(bitShifts)
//  nBytesPerPuid: \(nBytesPerPuid)
//  entropy: \(entropy)
//"""
//  }
//}

/// Static PuidInfo creation
extension Puid.Settings {

  typealias PuidInfo = (bits: Double, bitsPerChar: Double, nBytesPerPuid: Int, ere: Double, length: Int)
  typealias PuidBpcAndLen = (bpc: Double, len: Int)

  static func puidInfo(for chars: Puid.Chars, with bits: Double) -> PuidInfo {
    puidInfo(for: chars, using: try! puidBpcAndLen(chars, bits))
  }
  
  static func puidInfo(for chars: Puid.Chars, using bpcAndLen: PuidBpcAndLen) -> PuidInfo {
    let (bpc: bitsPerChar, len: length) = bpcAndLen
    
    let (_, charsByteCount) = chars.encoding()
    let avgRepBitsPerChar = 8.0 * Double(charsByteCount) / Double(chars.count)
    let ere = bitsPerChar / avgRepBitsPerChar
    
    let bitsPerPuid = bitsPerChar * Double(length)
    let nBytesPerPuid = Int(ceil(bitsPerPuid / 8))
    
    return(bits: Double(length) * bitsPerChar,
           bitsPerChar: bitsPerChar,
           nBytesPerPuid: nBytesPerPuid,
           ere: ere,
           length: length
    )
  }
  
  static func puidBpcAndLen(_ chars: Puid.Chars, _ bits: Double) throws -> PuidBpcAndLen {
    let bpc = chars.bitsPerChar
    let len = Int(round(ceil(bits / bpc)))
    return (bpc: bpc, len: len)
  }
}
