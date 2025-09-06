//
//  Puid.Chars.Metrics
//
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid.Chars {
  public struct Metrics: Sendable {
    public let avgBits: Double
    public let bitShifts: [BitShift]
    public let ere: Double
    public let ete: Double
  }

  public static func metrics(_ chars: Puid.Chars) -> Metrics {
    let count = chars.count
    let bitShiftsInternal = chars.bitShifts
    let bitShifts = bitShiftsInternal.map { BitShift(value: $0.value, shift: $0.shift) }

    let theoreticalBits = Puid.Util.log2i(count)

    let (_, charsByteCount) = chars.encoding()
    let avgRepBitsPerChar = 8.0 * Double(charsByteCount) / Double(count)
    let ere = theoreticalBits / avgRepBitsPerChar

    if Puid.Util.isPow2(count) {
      let avgBits = Double(Puid.Util.iCeil(theoreticalBits))
      return Metrics(avgBits: avgBits, bitShifts: bitShifts, ere: ere, ete: 1.0)
    }

    let nBitsPerChar = Puid.Util.iCeil(theoreticalBits)
    let totalValues = Puid.Util.iPow2(nBitsPerChar)

    let probAccept = Double(count) / Double(totalValues)
    let probReject = 1.0 - probAccept

    let rejectCount = totalValues - count
    let rejectBits = bitsConsumedOnReject(charsetSize: count, totalValues: totalValues, bitShifts: bitShiftsInternal)

    let avgBitsOnReject = Double(rejectBits) / Double(rejectCount)
    let avgBits = Double(nBitsPerChar) + (probReject / probAccept) * avgBitsOnReject

    let ete = theoreticalBits / avgBits

    return Metrics(avgBits: avgBits, bitShifts: bitShifts, ere: ere, ete: ete)
  }
}

public extension Puid.Chars {
  struct BitShift: Sendable {
    public let value: Int
    public let shift: Int
  }
}

private extension Puid.Chars {
  static func bitsConsumedOnReject(charsetSize: Int, totalValues: Int, bitShifts: [Puid.Bits.Shift]) -> Int {
    if charsetSize >= totalValues { return 0 }

    var sum = 0
    var value = charsetSize
    while value < totalValues {
      let shift = findBitShift(value: value, bitShifts: bitShifts)
      sum += shift
      value += 1
    }
    return sum
  }

  static func findBitShift(value: Int, bitShifts: [Puid.Bits.Shift]) -> Int {
    var i = 0
    while i < bitShifts.count {
      let rule = bitShifts[i]
      if value <= rule.value { return rule.shift }
      i += 1
    }
    fatalError("bitShifts \(bitShifts) has no matching bit shift rule for value \(value)")
  }
}

