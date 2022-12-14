//
//  BookListViewController.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import UIKit

class BookListViewController: UIViewController {
    /// BookList view model instance
    let viewModel = BookListViewModel()
    /// Page number for books list , Initial value set to 1
    var page: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initViewModel()
    }

    // MARK: Private methods

    /// Initialise view model with books data
    private func initViewModel() {
        loadBooks(with: "lord of the ring", page: page)
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                /// Reload data after books list is fetched. Stop refershing the list once
                /// loaded during pull down refresh.
                self?.reloadTable()
            }
        }
    }

    private func reloadTable() {
    }

    /// Loads the books data for page `page`
    private func loadBooks(with text: String, page: Int) {
        viewModel.loadBooks(with: text, page: page) { [weak self] status, error in
            guard let _ = self else {
                return
            }
        }
    }
}
