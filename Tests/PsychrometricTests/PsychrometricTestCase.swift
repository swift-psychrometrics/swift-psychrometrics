import Dependencies
import PsychrometricClientLive
import XCTest

class PsychrometricTestCase: XCTestCase {
  
  override func invokeTest() {
    withDependencies {
      $0.psychrometricClient = .liveValue
    } operation: {
      super.invokeTest()
    }
  }
}
