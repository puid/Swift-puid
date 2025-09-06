//
//  Puid.Util
//
//  MIT License: See project LICENSE.txt
//
import Foundation

extension Puid {
  struct Util {
    static func isBitZero(n: Int, bit: Int) -> Bool {
      precondition(bit > 0 && bit <= Int.bitWidth)
      return (n & (1 << (bit - 1))) == 0
    }
    
    static func iCeil(_ value: Double) -> Int {
      Int(ceil(value))
    }
    
    static func log2i(_ value: Int) -> Double {
      log2(Double(value))
    }
    
    static func floorLog2(_ n: Int) -> Int {
      precondition(n > 0)
      return Int.bitWidth - 1 - n.leadingZeroBitCount
    }
    
    static func ceilLog2(_ n: Int) -> Int {
      precondition(n > 0)
      let f = floorLog2(n)
      return isPow2(n) ? f : f + 1
    }
    
    static func isPow2(_ n: Int) -> Bool {
      n > 0 && (n & (n - 1)) == 0
    }
    
    static func iPow2(_ n: Int) -> Int {
      precondition(n >= 0 && n < Int.bitWidth)
      return 1 << n
    }
  }
}

extension Data {
  var hex: String {
    self.map { String(format: "%02x", $0) }.joined(separator: " ")
  }
  
  var binary: String {
    func padByte(_ byte: UInt8) -> String {
      var str = String(byte, radix: 2)
      for _ in 0..<(8 - str.count) {
        str = "0" + str
      }
      str.insert(" ", at: str.index(str.startIndex, offsetBy: 4))
      return str
    }

    return self.map { padByte($0) }.joined(separator: " ")
  }
}
