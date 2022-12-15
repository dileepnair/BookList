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
    /// Status flag to check if network call is in progress
    var isNetworkCallInProgress: Bool = false
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
        isNetworkCallInProgress = true
        let networkManager = NetworkManger.shared
        networkManager.getBooks(text: text, page: page) { [weak self] books, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if error != nil, let error = error {
                    completion(false, error)
                }
                guard let books = books else {
                    return
                }
                self?.books.append(contentsOf: books.docs)
                self?.isNetworkCallInProgress = false
            }
        }
    }
    
    func clearList() {
        self.books.removeAll()
    }
}
