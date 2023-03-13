//
//  Puid.Entropy.System.Prng
//  
//  MIT License: See project LICENSE.txt
//

import Foundation

extension Puid.Entropy.System {
  struct Prng {
    struct Generator: RandomNumberGenerator {
      func next() -> UInt64 {
        UInt64.random(in: UInt64.min ... UInt64.max)
      }
      
      static let method = "UInt64.random"
    }
  }
}
