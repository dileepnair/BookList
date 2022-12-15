//
//  NetworkManager.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import Foundation

/// Network responses
enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "Not able to decode the response."
}

/// Network Response type
enum Result<String>: LocalizedError {
    case success
    case failure(String)
}

/// NetworkService methods
public protocol NetworkServiceProtocol {
    func getBooks(text: String,
                  page: Int,
                  completion: @escaping (_ books: Books?, _ error: String?) -> Void)
}

/// Network manager which handles network requests in the app
public struct NetworkManger: NetworkServiceProtocol {
    /// NetworkManger shared instance
    static let shared: NetworkServiceProtocol = NetworkManger()
    /// Router instance
    let router = Router<BookListApi>()
    /// Private initialiser
    private init() {}

    /// Get the list of books for search text `text` and for page `page`
    /// - Parameters:
    ///   - text: text String value
    ///   - page: page Int value
    ///   - completion: completion handler with handles the returned Books and response error string
    public func getBooks(text: String, page: Int, completion: @escaping (Books?, String?) -> Void) {
        router.request(.bookSearch(text: text,
                                   page: page,
                                   limit: NetworkingConstants.booksLimit)) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                do {
                    let result = try self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let jsonDecoder = JSONDecoder()
                            let jsonData = try jsonDecoder.decode(Books.self, from: responseData)
                            completion(jsonData, nil)
                        } catch {
                            print(error)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let failureError):
                        completion(nil, failureError)
                    }
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) throws -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            throw Result.failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            throw Result.failure(NetworkResponse.badRequest.rawValue)
        case 600:
            throw Result.failure(NetworkResponse.outdated.rawValue)
        default:
            throw Result.failure(NetworkResponse.failed.rawValue)
        }
    }
}
