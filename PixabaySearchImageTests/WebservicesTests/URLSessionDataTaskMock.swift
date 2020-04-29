import Foundation
@testable import PixabaySearchImage

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {

  private(set) var resumeWasCalled = false

  func resume() {
    self.resumeWasCalled = true
  }
}
