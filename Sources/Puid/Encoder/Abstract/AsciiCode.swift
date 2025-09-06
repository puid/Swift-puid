//
//  Puid.AsciiCode
//
//  MIT License: See project LICENSE.txt
//

extension Puid {
  typealias AsciiCode = UInt8

  enum Ascii: AsciiCode {
    case bang = 33
    case hashTag = 35
    case ampersand = 38
    case openParen = 40
    case dash = 45
    case zero = 48
    case two = 50
    case six = 54
    case colon = 58
    case A = 65
    case B = 66
    case D = 68
    case F = 70
    case J = 74
    case L = 76
    case M = 77
    case P = 80
    case T = 84
    case V = 86
    case openSquareBracket = 91
    case closeSquareBracket = 93
    case underscore = 95
    case a = 97
    case b = 98
    case d = 100
    case f = 102
    case j = 106
    case m = 109
    case p = 112
    case t = 116
    case openCurlyBracket = 123
    case tilde = 126

    var code: AsciiCode {
      self.rawValue
    }
  }
}
