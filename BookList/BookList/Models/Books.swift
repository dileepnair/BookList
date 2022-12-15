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

public struct Book: Codable {
    let title: String
    let authorName: [String]?
    let titleSuggest: String
    let type: String
    let cover: Int?
    let publisher: [String]?
    let publishYear: Int?
}

extension Book {
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case titleSuggest = "title_suggest"
        case cover = "cover_i"
        case type
        case publishYear = "first_publish_year"
        case publisher
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        authorName = try values.decodeIfPresent([String].self, forKey: .authorName)
        titleSuggest = try values.decode(String.self, forKey: .titleSuggest)
        type = try values.decode(String.self, forKey: .type)
        cover = try values.decodeIfPresent(Int.self, forKey: .cover)
        publishYear = try values.decodeIfPresent(Int.self, forKey: .publishYear)
        publisher = try values.decodeIfPresent([String].self, forKey: .publisher)
    }
}
