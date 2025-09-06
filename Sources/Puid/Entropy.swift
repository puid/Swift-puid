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
        1 < risk
      else { return 0 }

      return log2(total) + log2(total - 1) + log2(risk) - 1.0
    }

    static func bits(total: Int, risk: Double) -> Double {
      bits(total: Double(total), risk: risk)
    }

    static func risk(total: Double, bits: Double) -> Double {
      guard 1 < total,
        1 < bits
      else { return 1 }

      let n = total * (total - 1)
      let m = pow(2, bits + 1)

      return 1 - exp(-n / m)
    }

    static func system(_ system: System) -> PuidEntropySource {
      switch system {
      case .csprng:
        return Puid.Entropy.System.CSPrng()
      case .prng:
        return Puid.Entropy.Source(
          using: Puid.Entropy.System.Prng.Generator(),
          method: Puid.Entropy.System.Prng.Generator.method)
      case .prngSeeded(let seed):
        return Puid.Entropy.Source(
          using: Puid.Entropy.System.Prng.Generator(seed: seed),
          method: Puid.Entropy.System.Prng.Generator.method)
      }
    }

  }
}
