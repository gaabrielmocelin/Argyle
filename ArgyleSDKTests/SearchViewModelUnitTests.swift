//
//  SearchViewModelUnitTests.swift
//  ArgyleTests
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import XCTest
@testable import ArgyleSDK

class SearchDelegate: SearchViewModelDelegate {
    var count = 0
    var expectation: XCTestExpectation!


    func didUpdateState(_ state: SearchState) {
        count += 1

        switch state {
        case .loaded, .error:
            expectation.fulfill()
        case .empty, .loading:
            break
        }
    }
}

final class SearchViewModelUnitTests: XCTestCase {
    var sut: SearchViewModel!
    var networkMock: MockNetworkService!
    var delegate: SearchDelegate!

    override func setUpWithError() throws {
        networkMock = MockNetworkService()
        delegate = SearchDelegate()
        sut = SearchViewModel(networkService: networkMock)
        sut.delegate = delegate
    }

    func testFetchSuccess() throws {
        let expectation = self.expectation(description: "linkItemsFetch")
        delegate.expectation = expectation
        networkMock.completionTime = 0.2

        XCTAssert(sut.state == .empty)

        sut.fetchItems(searchText: "abc")

        XCTAssert(sut.state == .loading)

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(sut.state == .loaded(items: SearchLinkItemsRequest().mock ?? []))
    }

    func testFetchFailure() throws {
        let expectation = self.expectation(description: "linkItemsFetch")
        delegate.expectation = expectation
        networkMock.shouldFail = true
        networkMock.completionTime = 0.2

        XCTAssert(sut.state == .empty)

        sut.fetchItems(searchText: "abc")

        XCTAssert(sut.state == .loading)

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(sut.state == .error(.unknown))
    }
    

    func testDebounce() throws {
        let expectation = self.expectation(description: "linkItemsFetch")
        expectation.isInverted = true

        delegate.expectation = expectation

        XCTAssert(sut.state == .empty)

        sut.search(for: "abc")
        sut.search(for: "abcd")

        XCTAssert(sut.state == .empty)

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssert(sut.state == .loading)
        XCTAssert(delegate.count == 1)
    }
}
