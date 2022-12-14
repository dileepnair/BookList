//
//  BookListViewModel.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import Foundation

class BookListViewModel {
    /// closure to update the UI
    var reloadTableView: (() -> Void)?
    /// NetworkServiceProtocol instance
    var service: NetworkServiceProtocol
    
    /// BookList array
    var books = [Book]() {
        didSet {
            reloadTableView?()
        }
    }

    /// BookListViewModel initialiser
    /// - Parameter service: NetworkServiceProtocol type
    init(service: NetworkServiceProtocol = NetworkManger.shared) {
        self.service = service
    }

    func loadBooks(with text: String,
                   page: Int,
                   completion: @escaping (Bool, String?) -> Void) {
        let networkManager = NetworkManger.shared
        networkManager.getBooks(text: text, page: page) { books, error in
            print(books)
        }
    }
}
