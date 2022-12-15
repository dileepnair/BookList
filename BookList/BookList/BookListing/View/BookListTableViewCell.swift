//
//  BookListTableViewCell.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

class BookListTableViewCell: UITableViewCell {
    @IBOutlet var bookTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(book: Book) {
        bookTitle.text = book.title
    }
}
