//
//  Puid.EntropySystem.CSPrng
//
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid.Entropy.System {
  struct CSPrng: PuidEntropySource {
    /// Fill the supplied `Data` with `count`bytes at the specified `offset` using sytem cryptographically strong bytes 
    ///
    /// - Parameter into: Data into which the bytes are copied
    /// - Parameter count: The number of bytes to generate
    /// - Parameter offset: Offset byte at which to begin copy
    ///
    /// - Throws: `PuidError.bytesFailure(status:)` if system entropy is not available
    func bytes(into data: inout Data, count: Int, offset: Int) throws {
      let status = data.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress! + offset)
      }
      guard status == errSecSuccess else {
        throw PuidError.bytesFailure(status: status)
      }
    }
    
    func method() -> String {
      "SecRandomCopyBytes"
    }
  }
}
