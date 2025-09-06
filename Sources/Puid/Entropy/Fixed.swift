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
  public final class Fixed: PuidEntropySource {
    var data: Data
    var bitOffset: Int = 0
    let bitCount: Int

    /// Create a Fixed generator using the specified data
    public init(data: Data) {
      self.data = data
      bitCount = 8 * data.count
    }

    /// Create a Fixed generator using the specified hex string as data
    public convenience init(hex: String) throws {
      let hexStr = hex.replacingOccurrences(of: " ", with: "")
      guard hexStr.count.isMultiple(of: 2) else { throw PuidError.dataSize }

      let chars = Array(hexStr)
      var bytes: [UInt8] = []
      bytes.reserveCapacity(chars.count / 2)
      var i = 0
      while i < chars.count {
        let pair = String([chars[i], chars[i + 1]])
        guard let b = UInt8(pair, radix: 16) else { throw PuidError.invalidChar }
        bytes.append(b)
        i += 2
      }

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
    /// - Throws: `PuidError.dataSize` if Data size is insufficient to accept count bytes starting at offset
    public func bytes(into data: inout Data, count: Int, offset: Int) throws {
      guard count + offset < data.count + 1 else { throw PuidError.dataSize }

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

    public var source: String {
      "Fixed Bytes"
    }
  }
}
