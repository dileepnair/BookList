//
//  UIImageView+Extension.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

/// UIImage view extension
extension UIImageView {
    /// Load image , cache the image and set the image views image
    func downloadImage(from imageUrl: String, completion: @escaping (URLSessionDataTask?, Bool) -> Void) {
        var task: URLSessionDataTask?
        guard let url = URL(string: imageUrl) else { return completion(nil, false) }
        // Set initial image to nil so it doesn't use the image from a reused cell
        image = nil
        // Check if the image is already in the cache
        if let imageToCache = imageCache.object(forKey: imageUrl as NSString) {
            self.image = imageToCache
            completion(nil, true)
        }
        // Download the image asynchronously
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                print(err)
                completion(nil, false)
            }
            DispatchQueue.main.async {
                // create UIImage
                guard let data = data, let imageToCache = UIImage(data: data) else {
                    completion(nil, false)
                    return
                }
                /// add the image to cache
                imageCache.setObject(imageToCache, forKey: imageUrl as NSString)
                self.image = imageToCache
                completion(task, true)
            }
        }
        if let task = task {
            task.resume()
        }
    }
}
