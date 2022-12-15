//
//  BookDetailViewModelTests.swift
//  BookListTests
//
//  Created by Dileep Nair on 12/15/22.
//

import XCTest
@testable import BookList

final class BookDetailViewModelTests: XCTestCase {
    var viewModel: BookDetailsViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        viewModel = BookDetailsViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        viewModel = nil
    }

    func test_View_Model() {
        XCTAssertNotNil(viewModel)
        XCTAssertNil(viewModel.book)
    }
}
