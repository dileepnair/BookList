//
//  Books.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import Foundation

public struct Books: Decodable {
    let docs: [Book]
}

public struct Book: Decodable {
    let title: String
}
