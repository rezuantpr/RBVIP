import XCTest
@testable import RBVIP

final class RBVIPTests: XCTestCase {
  
    func testExample() {
      let module = AppModules.test.build()
      
      let vc = module.view as! UIViewController 
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

}
