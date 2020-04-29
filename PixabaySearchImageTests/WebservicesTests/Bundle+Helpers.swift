import XCTest

extension XCTestCase {
  private var currentBundle: Bundle { Bundle(for: type(of: self)) }
  func getDataFromJSON(in fileName: String) -> Data? { currentBundle.getDataFromJSON(in: fileName) }
  func getImageData(from fileName: String, type: String) -> Data? { currentBundle.getImageData(from: fileName, type: type) }
}

extension Bundle {
  func getDataFromJSON(in fileName: String) -> Data? {
    guard let path = self.path(forResource: fileName, ofType: "json"),
      let string = try? String(contentsOfFile: path),
      let data = string.data(using: .utf8) else { return nil }
    return data
  }

  func getImageData(from fileName: String, type: String) -> Data? {
    guard let path = self.path(forResource: fileName, ofType: type),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
    return data
  }

}
