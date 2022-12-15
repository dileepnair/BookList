//
//  BookListViewController.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import UIKit

class BookListViewController: UIViewController {
    // MARK: Internal properties

    /// BookList view model instance
    let viewModel = BookListViewModel()
    /// Page number for books list , Initial value set to 1
    var page: Int = 1

    // MARK: IBOutlet properties

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var okayButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: Private methods

    /// Initialise view model with books data
    private func searchBook(with text: String) {
        loadBooks(with: text, page: page)
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                /// Reload data after books list is fetched. Stop refershing the list once
                /// loaded during pull down refresh.
                self?.reloadTable()
            }
        }
    }

    private func reloadTable() {}

    /// Loads the books data for page `page`
    private func loadBooks(with text: String, page: Int) {
        viewModel.loadBooks(with: text, page: page) { [weak self] _, _ in
            guard let _ = self else {
                return
            }
        }
    }

    @IBAction func okayButtonAction() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            DispatchQueue.main.async {
                /// displays error alert if any error
                self.displayError(title: BookListConstants.errorAlertTitle,
                                  message: BookListConstants.searchErrorText)
            }
            return
        }
        searchBook(with: searchText)
    }
}

/// Error handler which presents error alert in view controller
extension BookListViewController: ErrorHandler {}
