//
//  PuidAsciiMapProtocol
//  
//  MIT License: See project LICENSE.txt
//

protocol PuidAsciiMapProtocol {
  func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode
}
