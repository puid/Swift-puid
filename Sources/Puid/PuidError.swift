//
//  PuidError.swift
//
//  MIT License: See project LICENSE.txt
//

import Foundation

/// Error type thrown by **PUID** package functions
enum PuidError: Error {
  case bytesExhausted
  case bytesFailure(status: EntropyStatus)
  case charsNotUnique
  case dataSize
  case invalidChar
  case invalidEncoder
  case invalidEncoding(puidNdx: PuidNdx)
  case tooFewChars
  case tooManyChars
  
  public var description: String {
    switch self {
      case .bytesFailure(let status):
        return "Failed to generate bytes with status: \(status)"
      case .bytesExhausted:
        return "Bytes are exhuasted"
      case .charsNotUnique:
        return "Characters not unique"
      case .dataSize:
        return "Data not sufficient to accept count bytes starting at offset"
      case .invalidChar:
        return "Invalid character"
      case .invalidEncoder:
        return "Invalid encoder: override Encoder.encode method"
      case .invalidEncoding(let puidNdx):
        return "Invalid encoding: puidNdx=\(puidNdx) not support by encoder"
      case .tooFewChars:
        return "Require at least 2 characters"
      case .tooManyChars:
        return "Exceed max of \(Puid.Chars.maxCount) characters"
    }
  }
}
