//
//  Endpoints.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import Foundation

/// Type of supported Httpmethods
public enum HTTPMethod: String {
    case get = "GET"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParams: [String: String] { get }
}

public enum BookListApi {
    case bookSearch(text: String, page: Int, limit: Int)
}

/// BookListApi extension , implements EndPointType
extension BookListApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: NetworkingConstants.baseUrl) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var path: String {
        switch self {
        case .bookSearch:
            return "search.json"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var headers: [String: String] {
        [:]
    }

    var queryParams: [String: String] {
        switch self {
        case let .bookSearch(text, page, limit):
            return ["q": String(text), "page": String(page), "limit": String(limit)]
        }
    }
}
