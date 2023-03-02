//
//  CompareTest.swift
//  
//
//  Created by Paul Rogers on 2023-02-25.
//

import XCTest
import Puid

final class CompareTest: XCTestCase {

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }
  
  func testPerformanceExample() throws {
    let trials = 10_000
    
    measure {
      do {
        let defaultId = try Puid()
        for _ in 0..<trials {
          let _ = try defaultId.generate()
        }
      } catch {}
    }
    
//    let password = Gen.letterOrNumber
//    // Generate 6-character strings of them.
//      .string(of: .always(6))
  }
}
