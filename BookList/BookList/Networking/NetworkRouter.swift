//
//  NetworkRouter.swift
//  BookList
//
//  Created by Dileep Nair on 12/14/22.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,
                                            _ response: URLResponse?,
                                            _ error: Error?) -> Void

// Network router protocol to handle the request
protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        guard let task = task else {
            return
        }
        task.resume()
    }

    func cancel() {
        guard let task = task else {
            return
        }
        task.cancel()
    }

    /// Build URlrequest from the endpoint values
    /// - Parameter route: route EndPont type
    /// - Returns: URLRequest value
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var url: URL = route.baseURL.appendingPathComponent(route.path)
        if let queryItemUrl = buildUrlParamters(url: url, route: route) {
            url = queryItemUrl
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        route.headers.forEach({ (key, value) in
            request.setValue(key, forHTTPHeaderField: value)
        })
        return request
    }

    fileprivate func buildUrlParamters(url: URL, route: EndPoint) -> URL? {
        var queryItem: URLQueryItem?
        var components = URLComponents(string: url.absoluteString)
        var queryItems: [URLQueryItem] = []
        route.queryParams.forEach { (key: String, value: String) in
            queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem!)
        }
        components?.queryItems = queryItems
        guard let componentUrl = components?.url else { return nil}
        return componentUrl
    }
}
