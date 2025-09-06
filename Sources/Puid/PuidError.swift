//
//  PuidError.swift
//
//  MIT License: See project LICENSE.txt
//

import Foundation

/// Error type thrown by **PUID** package functions
public enum PuidError: Error {
  case bytesExhausted
  case bytesFailure(status: Int32)
  case charsNotUnique
  case dataSize
  case invalidChar
  case invalidEncoder
  case invalidEncoding(puidNdx: UInt8)
  case tooFewChars
  case tooManyChars
  
  public var description: String {
    switch self {
      case .bytesFailure(let status):
        return "Failed to generate bytes with status: \(status)"
      case .bytesExhausted:
        return "Bytes are exhausted"
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

public extension PuidError {
  enum Code: Int {
    case bytesExhausted
    case bytesFailure
    case charsNotUnique
    case dataSize
    case invalidChar
    case invalidEncoder
    case invalidEncoding
    case tooFewChars
    case tooManyChars
  }
  
  var code: Code {
    if case .bytesExhausted = self { return .bytesExhausted }
    else if case .bytesFailure = self { return .bytesFailure }
    else if case .charsNotUnique = self { return .charsNotUnique }
    else if case .dataSize = self { return .dataSize }
    else if case .invalidChar = self { return .invalidChar }
    else if case .invalidEncoder = self { return .invalidEncoder }
    else if case .invalidEncoding = self { return .invalidEncoding }
    else { return .tooFewChars }
  }
}

extension PuidError: LocalizedError {
  public var errorDescription: String? { description }
}
