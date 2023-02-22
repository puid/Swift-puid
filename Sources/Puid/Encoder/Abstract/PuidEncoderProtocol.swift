//
//  PuidEncoderProtocol
//
//  MIT License: See project LICENSE.txt
//

protocol PuidEncoderProtocol {
  func encode(_ ndxs: PuidNdxs) throws -> String
}
