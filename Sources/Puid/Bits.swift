//
//  Puid.Bits
//  
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid {
  class Bits {
    typealias Shift = (value: Int, shift: Int)
    
    let settings: Settings
    
    var puidData: Data
    var bitOffset: Int
    var ndxShift: [Int]

    let bitCount: Int
    let nBitsPerChar: Int
    let nChars: Int
    
    let puidUsesExactlyNBytes: Bool
    let charsCountIsPow2: Bool
    
    init(settings: Settings) {
      self.settings = settings

      nChars = settings.chars.count
      
      charsCountIsPow2 = Util.isPow2(nChars)
      puidUsesExactlyNBytes = charsCountIsPow2 && (settings.nBytesPerPuid % 8 == 0)
      
      if puidUsesExactlyNBytes {
        puidData = Data(count: settings.nBytesPerPuid)
      } else {
        puidData = Data(count: settings.nBytesPerPuid + 1)
      }
      
      bitCount = 8 * puidData.count
      bitOffset = bitCount
      nBitsPerChar = Int(ceil(settings.bitsPerChar))
      
      let ndxCount = settings.bitShifts.last!.value
      ndxShift = (0...ndxCount).map { ndx in
        settings.bitShifts.first(where: { ndx <= $0.value })!.shift
      }
    }
    
    func puidNdxs() throws -> PuidNdxs {
      var ndxs = PuidNdxs(repeating: 0, count: settings.length)
      var ndx = 0
      repeat {
        ndxs[ndx] = try parseNdx()
        ndx += 1
      } while ndx < settings.length
      
      return ndxs
    }
    
    private func parseNdx() throws -> PuidNdx {
      while true {
        try fillEntropy()
        let ndx = sliceBits()
        if ndx < nChars {
          bitOffset += nBitsPerChar
          return ndx
        }
        bitOffset += ndxShift[Int(ndx)]
      }
    }
  
    private func sliceBits() -> PuidNdx {
      let lByteNdx = bitOffset >> 3
      let lByte = puidData[lByteNdx]
      let lBitNum = bitOffset % 8
      
      if (lBitNum + nBitsPerChar <= 8) {
        return ((lByte << lBitNum) & 0xff) >> (8 - nBitsPerChar)
      }
      
      let rByte = puidData[lByteNdx + 1]
      let rBitNum = lBitNum + nBitsPerChar - 8
      
      let lValue = ((lByte << lBitNum) & 0xff) >> (lBitNum - rBitNum)
      let rValue = rByte >> (8 - rBitNum)
      
      return lValue + rValue
    }
    
    private func fillEntropy() throws {
      guard bitCount < bitOffset + nBitsPerChar else { return }
      
      if puidUsesExactlyNBytes {
        try settings.entropy.bytes(into: &puidData, count: puidData.count, offset: 0)
        bitOffset = 0
      } else {
        /// Carry last byte and generate a new bytes
        puidData[0] = puidData[puidData.count-1]
        try settings.entropy.bytes(into: &puidData, count: puidData.count - 1, offset: 1)
        bitOffset = 8 - (bitCount - bitOffset)
        return
      }
    }
  }
}
