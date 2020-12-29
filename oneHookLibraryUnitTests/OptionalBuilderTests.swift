import XCTest
@testable import oneHookLibrary

class OptionalBuilderTests: XCTestCase {

    var optionalView: OptionalBuilder<UIView>!

    override func setUp() {
        super.setUp()

        optionalView = optionalBuilder {
            UIView()
        }
    }

    func testDoesNotExistWithoutBuild() {
        XCTAssertFalse(optionalView.exists)
    }

    func testDoesExistWithBuild() {
        _ = optionalView.getOrMake()

        XCTAssertTrue(optionalView.exists)
    }

    func testDoesNotExistWithClear() {
        _ = optionalView.getOrMake()
        optionalView.clear()

        XCTAssertFalse(optionalView.exists)
    }

    func testIfExistsNotCalledWithoutValue() {
        optionalView.ifExists { (_) in
            XCTFail("OptionalBuilder ifExists called without value")
        }
    }

    func testIfExistsCalledWithValue() {
        let expectation = XCTestExpectation(description: "OptionalBuilder ifExists called with value")

        _ = optionalView.getOrMake()

        optionalView.ifExists { (_) in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
