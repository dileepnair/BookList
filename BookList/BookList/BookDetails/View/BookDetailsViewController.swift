//
//  BookDetailsViewController.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

class BookDetailsViewController: UIViewController {
    // MARK: Internal properties

    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    /// BookDetailsViewModel instance
    lazy var viewModel = BookDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage(view: coverImageView)
        // Do any additional setup after loading the view.
    }

    // MARK: Initialiser method

    /// BookDetailsViewController Failable initialiser
    init?(with book: Book, coder: NSCoder) {
        super.init(coder: coder)
        viewModel.book = book
        viewModel.reloadView = {
            /// Update the UI once the book value is set
            DispatchQueue.main.async {
                self.titleLabel.text = book.title
                self.authorLabel.text = book.authorName?.first
                self.yearLabel.text = book.publishYear?.stringValue
                self.publisherLabel.text = book.publisher?.first
                guard let image = book.cover else {
                    return
                }
                let url = "\(NetworkingConstants.coverUrl)\(image)-L.jpg"
                self.coverImageView.downloadImage(from: url) { _, status in
                    if !status {
                        DispatchQueue.main.async {
                            self.displayError(title: BookListConstants.errorAlertTitle, message: "Error loading image")
                        }
                    }
                }
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupImage(view: UIView) {
        view.layer.cornerRadius = BookListConstants.bookImageCornerRadius
    }
}

/// Error handler which presents error alert in view controller
extension BookDetailsViewController: ErrorHandler {}
