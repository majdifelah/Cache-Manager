import Foundation
@testable import PixabaySearchImage

class URLSessionMock: URLSessionProtocol {

  var nextDataTask = URLSessionDataTaskMock()
  private var data: Data?
  private var urlResponse: URLResponse?
  private let taskError: Error?

  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.taskError = error
  }

  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    completionHandler(self.data, self.urlResponse, self.taskError)
    return self.nextDataTask
  }
}
