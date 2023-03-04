//
//  Puid.Entropy.System
//
//  MIT License: See project LICENSE.txt
//
extension Puid.Entropy {
  public enum System {
    /// Generate bytes using system cryptographically strong bytes
    case csprng
    
    /// Generate bytes using system entropy that may not have security characteristics
    case prng
  }
}
