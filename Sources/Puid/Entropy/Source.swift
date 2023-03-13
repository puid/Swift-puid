//
//  Puid.Entropy.Generator
//  
//  MIT License: See project LICENSE.txt
//
import Foundation

public extension Puid.Entropy {
  class Source: PuidEntropySource {
    
    var randomNumber: RandomNumberGenerator
    let entropyMethod: String
    
    var randomBytes: UInt64 = 0
    let randomByteCount = MemoryLayout<UInt64>.size
    var randomByteOffset: Int
    
    public init(using generator: RandomNumberGenerator, method: String = "Not Specified") {
      randomNumber = generator
      entropyMethod = method

      randomByteOffset = randomByteCount
    }
    
    /// Fill `Data` with `count` bytes at the specified `offset` using the initializer
    /// `RandomNumberGenerator` as theM entropy source
    ///
    /// - Parameter into: Data into which the bytes are copied
    /// - Parameter count: The number of bytes to generate
    /// - Parameter offset: Offset byte at which to begin copy
    ///
    /// - Throws: `PuidError.dataSize` if Data size is insufficient to accept count bytes starting at offset
    public func bytes(into data: inout Data, count: Int, offset: Int) throws {
      guard count + offset <= data.count else { throw PuidError.dataSize }
      
      let remainingByteCount = randomByteCount - randomByteOffset

      // Remaining bytes cover request
      if count < remainingByteCount {
        withUnsafeBytes(of: randomBytes) { bytesPtr in
          data.replaceSubrange(offset..<(offset + count),
                               with: bytesPtr.baseAddress! + randomByteOffset,
                               count: count)
        }
        randomByteOffset += count
        return
      }

      // Track data byte index
      var dataByteNdx = 0

      // Use remaining random bytes
      if 0 < remainingByteCount {
        withUnsafeBytes(of: randomBytes) { randomBytesPtr in
          data.replaceSubrange(offset..<(offset + remainingByteCount),
                               with: randomBytesPtr.baseAddress! + randomByteOffset,
                               count: remainingByteCount)
          dataByteNdx = remainingByteCount
        }
      }

      // Fill UInt64 sized chunks
      let chunks = (count - dataByteNdx) / randomByteCount
      if 0 < chunks {
        data.withUnsafeMutableBytes { dataPtr in
          (0..<chunks).forEach { chunk in
            randomBytes = randomNumber.next()
            dataPtr.storeBytes(of: randomBytes,
                               toByteOffset: offset + dataByteNdx + (chunk * randomByteCount),
                               as: UInt64.self)
          }
        }
        dataByteNdx += chunks * randomByteCount
      }
      
      // Next random bytes
      randomBytes = randomNumber.next()
      randomByteOffset = 0
      
      // Fill remaining data bytes
      let dataBytesLeft = count - dataByteNdx
      if 0 < dataBytesLeft {
        withUnsafeBytes(of: randomBytes) { randomBytesPtr in
          data.replaceSubrange((offset + dataByteNdx)..<(offset + dataByteNdx + dataBytesLeft),
                               with: randomBytesPtr.baseAddress!,
                               count: dataBytesLeft)
        }
      }
      randomByteOffset = dataBytesLeft
    }
    
    public func method() -> String {
      return entropyMethod
    }
  }
}
