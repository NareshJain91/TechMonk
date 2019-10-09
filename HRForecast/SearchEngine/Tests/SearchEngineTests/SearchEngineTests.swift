import XCTest
@testable import SearchEngine

final class SearchEngineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SearchEngine().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
