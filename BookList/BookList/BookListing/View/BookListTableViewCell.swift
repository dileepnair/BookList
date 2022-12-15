//
//  BookListTableViewCell.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

class BookListTableViewCell: UITableViewCell {
    // MARK: IBOutlet properties

    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var coverImageView: UIImageView!

    // MARK: Internal properties

    /// Populate cell with Book data
    var book: Book? {
        didSet {
            guard let book = book else {
                return
            }
            bookTitle.text = book.title
            if task == nil {
                guard let image = book.cover else {
                    coverImageView.image = UIImage(systemName: "book")
                    stopSpinner()
                    return
                }
                addSpinner()
                let url = "\(NetworkingConstants.coverUrl)\(image)-S.jpg"
                /// Load image from url and cache the image. ignores fetching image , if already cached image exists
                coverImageView.downloadImage(from: url) { [weak self] task, status in
                    if !status {
                        print("error")
                        self?.coverImageView.image = UIImage(systemName: "book")
                    }
                    self?.task = task
                    self?.stopSpinner()
                }
            }
        }
    }

    // MARK: Private properties

    private var spinner = UIActivityIndicatorView()
    private var task: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverImageView.layer.cornerRadius = BookListConstants.bookImageCornerRadius
        setupImage(view: coverImageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelTask()
        coverImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Private methods

    private func setupImage(view: UIView) {
        DispatchQueue.main.async { [weak self] in
            self?.coverImageView.image = UIImage(systemName: "book")
            self?.coverImageView.round(corners: [.topLeft, .bottomLeft],
                                       cornerRadius: BookListConstants.bookImageCornerRadius)
            self?.coverImageView.contentMode = .scaleToFill
        }
    }

    private func addSpinner() {
        spinner.center = coverImageView.center
        coverImageView.addSubview(spinner)
        spinner.startAnimating()
    }

    private func stopSpinner() {
        spinner.stopAnimating()
    }

    private func cancelTask() {
        task?.cancel()
        task = nil
    }

    // MARK: Internal methods

    func configure(book: Book) {
        self.book = book
    }
}
