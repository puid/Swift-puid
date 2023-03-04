//
//  PuidEntropySource
//
//  MIT License: See project LICENSE.txt
//

import Foundation

public protocol PuidEntropySource {
  /// Fill the supplied `Data` with `count` bytes at the specified `offset`
  ///
  /// - Parameter into: Data into which the bytes are copied
  /// - Parameter count: The number of bytes to generate
  /// - Parameter offset: Offset byte at which to begin copy
  ///
  func bytes(into: inout Data, count: Int, offset: Int) throws
  
  /// Description of the method used to generate entropy bytes
  func method() -> String
}
