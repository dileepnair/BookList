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
    
    var bookSearchText: String = ""

    // MARK: IBOutlet properties

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var okayButton: UIButton!
    @IBOutlet var bookListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bookListTableView.estimatedRowHeight = 300.0
        reloadTableData()
    }

    // MARK: Private methods

    private func reloadTableData() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                /// Reload data after books list is fetched. Stop refershing the list once
                /// loaded during pull down refresh.
                self?.reloadTable()
            }
        }
    }
    /// Initialise view model with books data
    private func searchBook(with text: String) {
        loadBooks(with: text, page: page)
        reloadTableData()
    }

    private func reloadTable() {
        bookListTableView.reloadData()
    }

    /// Loads the books data for page `page`
    private func loadBooks(with text: String, page: Int) {
        viewModel.loadBooks(with: text, page: page) { [weak self] status, error in
            guard let self = self else {
                return
            }
            if !status {
                DispatchQueue.main.async {
                    guard let error = error else {
                        return
                    }
                    /// displays error alert if any error
                    self.displayError(title: BookListConstants.errorAlertTitle, message: error)
                    self.reloadTable()
                }
            }
        }
    }

    /// Create footer view for pagination
    /// - Returns: UIView value
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: BookListConstants.footerViewHeight))
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        return footerView
    }

    // MARK: IBOutlet Methods

    @IBAction func okayButtonAction() {
        viewModel.clearList()
        guard let searchText = searchBar.text else {
            DispatchQueue.main.async {
                /// displays error alert if any error
                self.displayError(title: BookListConstants.errorAlertTitle,
                                  message: BookListConstants.searchErrorText)
            }
            return
        }
        let trimmedString = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedString.isEmpty else {
            DispatchQueue.main.async {
                /// displays error alert if any error
                self.displayError(title: BookListConstants.errorAlertTitle,
                                  message: BookListConstants.searchEmptyText)
            }
            return
        }
        bookSearchText = trimmedString
        searchBook(with: trimmedString)
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "BookListTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                    for: indexPath) as? BookListTableViewCell {
            cell.configure(book: viewModel.books[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

/// Error handler which presents error alert in view controller
extension BookListViewController: ErrorHandler {}

// MARK: UIScrollViewDelegate method
extension BookListViewController: UIScrollViewDelegate {
    /// Load the next page on scroll towards the last row in the tableview list
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        /// Shows loading indicator in tableview footer when user scrolls the tableview
        /// towards the end of the loaded list
        /// Then , start loading the next 10 records. page variable is the page number
        if position > ((bookListTableView.contentSize.height) - scrollView.frame.size.height) {
            self.bookListTableView.tableFooterView = createFooterView()
            guard !(self.viewModel.isNetworkCallInProgress) else {
                return
            }
            self.page += 1
            self.loadBooks(with: bookSearchText, page: self.page)
        }
    }
}
