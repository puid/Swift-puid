//
//  Puid.Entropy
//
//  MIT License: See project LICENSE.txt
//
import Foundation

extension Puid {
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
    
    static func system(_ system: System) -> PuidEntropySource {
      switch system {
        case .csprng:
          return Puid.Entropy.System.CSPrng()
        case .prng:
          return Puid.Entropy.System.Prng()
      }
    }
  }
}
