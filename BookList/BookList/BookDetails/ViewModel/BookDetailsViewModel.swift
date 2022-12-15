//
//  BookDetailsViewModel.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import Foundation

/// BookDetailsViewModel class
class BookDetailsViewModel {
    /// Closure which update the UI
    var reloadView: (() -> Void)?
    var book: Book? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadView?()
            }
        }
    }

    /// BookDetailsViewModel initialiser
    /// - Parameter book: Book Optional value. default value is nil
    init(book: Book? = nil) {
        self.setBook(newValue: book)
    }

    private func setBook(newValue: Book? = nil) {
        self.book = newValue
    }
}
