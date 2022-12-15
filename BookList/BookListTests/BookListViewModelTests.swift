//
//  BookListViewModelTests.swift
//  BookListTests
//
//  Created by Dileep Nair on 12/15/22.
//

import XCTest
@testable import BookList

final class BookListViewModelTests: XCTestCase {
    var viewModel: BookListViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        viewModel = BookListViewModel()
        let book1 = Book(title: "Lord of ring",
                         authorName: ["Rowling"],
                         titleSuggest: "Lord",
                         type: "Book",
                         cover: 2132,
                         publisher: ["publisher"],
                         publishYear: 1999)
        let books: [Book] = [book1]
        viewModel.books = books
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        viewModel = nil
    }

    func test_view_model() {
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.service)
    }

    func test_books_data() throws {
        let books = viewModel.books
        XCTAssertEqual(books.count, 1)
        let selectedBook = try XCTUnwrap(books.first)
        XCTAssertEqual(selectedBook.title, "Lord of ring")
        XCTAssertEqual(selectedBook.authorName, ["Rowling"])
        XCTAssertEqual(selectedBook.publisher, ["publisher"])
        XCTAssertEqual(selectedBook.publishYear, 1999)
        XCTAssertEqual(selectedBook.cover, 2132)
        XCTAssertEqual(selectedBook.type, "Book")
    }

    func test_clear_books() {
        viewModel.clearList()
        XCTAssertTrue(viewModel.books.isEmpty)
    }

    func test_book_list() {
        viewModel.clearList()
        let expectation = expectation(description: "Book list")
        viewModel.loadBooks(with: "Lord", page: 1) { _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 6)
        let books = viewModel.books
        XCTAssertEqual(books.count, 10)
    }
}
