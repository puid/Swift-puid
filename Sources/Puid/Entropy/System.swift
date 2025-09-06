//
//  Puid.Entropy.System
//
//  MIT License: See project LICENSE.txt
//
extension Puid.Entropy {
  public enum System {
    case csprng
    case prng
    case prngSeeded(seed: UInt64)
  }
}

