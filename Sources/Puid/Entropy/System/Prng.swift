//
//  Puid.Entropy.System.Prng
//  
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid.Entropy.System {
  struct Prng: PuidEntropySource {
    /// Fill the supplied `Data` with `count` bytes at the specified `offset` using system entropy that may not have
    /// secure properties
    ///
    /// - Parameter into: Data into which the bytes are copied
    /// - Parameter count: The number of bytes to generate
    /// - Parameter offset: Offset byte at which to begin copy
    ///
    /// - Throws: This function is marked `throws` by the protocol but will not actually throw any errors
    func bytes(into data: inout Data, count: Int, offset: Int) throws {
      (offset..<(offset+count)).forEach { ndx in
        data[ndx] = UInt8.random(in: UInt8.min ... UInt8.max)
      }
    }
    
    func method() -> String {
      "UInt8.random"
    }
  }
}
