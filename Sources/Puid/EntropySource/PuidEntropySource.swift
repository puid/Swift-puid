//
//  PuidEntropySource
//
//  MIT License: See project LICENSE.txt
//

import Foundation

public protocol PuidEntropySource {
  /// Fill the supplied `Data` with `count` bytes at the specified `offset`
  ///
  /// - Parameter into: Data into which the bytes are copied
  /// - Parameter count: The number of bytes to generate
  /// - Parameter offset: Offset byte at which to begin copy
  ///
  func bytes(into: inout Data, count: Int, offset: Int) throws
  
  /// Description of the method used to generate entropy bytes
  func method() -> String
}

extension Puid {
  //
  //  Puid.Entropy
  //
  public struct Entropy {
    
    static func bits(total: Double, risk: Double) -> Double {
      guard 1 < total,
            1 < risk else { return 0 }
      
      let n = total < 1000 ? log2(total) + log2(total - 1) : 2 * log2(total)
      
      return n + log2(risk) - 1.0
    }
    
    static func bits(total: Int, risk: Double) -> Double {
      bits(total: Double(total), risk: risk)
    }
    
    static func source(_ system: Puid.Entropy.Source) -> PuidEntropySource {
      switch system {
        case .csprng:
          return Puid.Entropy.System.CSPrng()
        case .prng:
          return Puid.Entropy.System.Prng()
      }
    }
    
    //
    //  Puid.Entropy.Source
    //
    public enum Source {
      /// Generate bytes using system cryptographically strong bytes
      case csprng
      
      /// Generate bytes using system entropy that may not have security characteristics
      case prng
    }
    
    //
    //  Puid.Entropy.System
    //
    public struct System {}
  }
}
