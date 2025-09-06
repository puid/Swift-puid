//
//  Puid.Entropy.System.Prng
//
//  MIT License: See project LICENSE.txt
//

import Dispatch
import Foundation

extension Puid.Entropy.System {
  struct Prng {
    struct Generator: RandomNumberGenerator {
      private var state: UInt64

      init(seed: UInt64) {
        // Avoid zero seed
        self.state = seed != 0 ? seed : 0x9E37_79B9_7F4A_7C15
      }

      init() {
        let seed = UInt64(truncatingIfNeeded: DispatchTime.now().uptimeNanoseconds)
        self.init(seed: seed)
      }

      mutating func next() -> UInt64 {
        // xorshift64*
        state ^= state >> 12
        state ^= state << 25
        state ^= state >> 27
        return state &* 2_685_821_657_736_338_717
      }

      static let method = "XorShift64*"
    }
  }
}
