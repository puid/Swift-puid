//
//  Puid.Entropy.Fixed
//  
//  MIT License: See project LICENSE.txt
//
import Foundation

extension Puid.Entropy {
  /// A **PUID** bytes generator that uses fixed bytes
  ///
  /// This generator is useful for deterministic testing and not intended for production use
  public class Fixed: PuidEntropySource {
    var data: Data
    var bitOffset: Int = 0
    let bitCount: Int

    /// Create a Fixed generator using the specified data
    public init(data: Data) {
      self.data = data
      bitCount = 8 * data.count
    }

    /// Create a Fixed generator using the specified hex string as data
    public convenience init(hex: String) {
      var hexStr = hex.replacingOccurrences(of: " ", with: "")
      if !hexStr.count.isMultiple(of: 2) {
        hexStr += "0"
      }
      
      let chars = hexStr.map { $0 }
      let bytes = stride(from: 0, to: chars.count, by: 2)
        .map { String(chars[$0]) + String(chars[$0 + 1]) }
        .compactMap { Byte($0, radix: 16) }
      
      self.init(data: Data(bytes))
    }
    
    /// Fill the supplied `Data` with `count` bytes at the specified `offset` using the initialized
    /// fixed bytes
    ///
    /// - Parameter into: Data into which the bytes are copied
    /// - Parameter count: The number of bytes to generate
    /// - Parameter offset: Offset byte at which to begin copy
    ///
    /// - Throws: `PuidError.bytesExhausted` if there are not enough bytes to fulfil the request
    public func bytes(into data: inout Data, count: Int, offset: Int) throws {
      let nBitsNeeded = count << 3
      
      guard bitOffset + nBitsNeeded <= bitCount else {
        throw PuidError.bytesExhausted
      }
      
      let startByte = Int(ceil(Double(bitOffset) / 8))
      
      (0..<count).forEach { ndx in
        data[ndx + offset] = self.data[startByte + ndx]
      }
      bitOffset += nBitsNeeded
    }
    
    /// Resets the generation of bytes back to the beginning of the initial bytes array
    public func reset() {
      bitOffset = 0
    }
    
    public func method() -> String {
      return "Fixed Bytes"
    }
  }
}
