//
//  Risk.swift
//
//  MIT License: See project LICENSE.txt
//

public struct RepeatRisk: Sendable {
  public let oneIn: Double
  
  public init(oneIn: Double) {
    precondition(oneIn > 1, "oneIn must be > 1")
    self.oneIn = oneIn
  }
  
  public static func oneIn(_ n: Double) -> RepeatRisk {
    RepeatRisk(oneIn: n)
  }
  
  public static func probability(_ p: Double) -> RepeatRisk {
    precondition(0 < p && p < 1, "probability must be in (0,1)")
    return RepeatRisk(oneIn: 1.0 / p)
  }
}

public extension Puid {
  init(total: Int,
       risk: RepeatRisk,
       chars: Puid.Chars = Puid.Default.chars,
       entropy: PuidEntropySource = Puid.Default.entropy) throws {
    precondition(total > 1, "total must be > 1")
    try self.init(total: Double(total), risk: risk.oneIn, chars: chars, entropy: entropy)
  }
  
  init(total: Int,
       risk: RepeatRisk,
       chars: Puid.Chars = Puid.Default.chars,
       entropy system: Puid.Entropy.System) throws {
    try self.init(total: Double(total), risk: risk.oneIn, chars: chars, entropy: Puid.Entropy.system(system))
  }
}

