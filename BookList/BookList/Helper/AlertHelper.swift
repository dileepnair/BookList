//
//  AlertHelper.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

/// Present alert on current view controller
public struct AlertHelper {
    static func present(in parent: UIViewController,
                        title: String,
                        message: String,
                        style: UIAlertController.Style = .alert,
                        actionTitle: String? = "OK",
                        actionStyle: UIAlertAction.Style = .default,
                        handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: actionTitle, style: actionStyle) { _ in
            handler?()
        }
        alertController.addAction(okAction)
        parent.present(alertController, animated: true, completion: nil)
    }
}

public protocol ErrorHandler {
    func displayError(title: String, message: String)
}

public extension ErrorHandler where Self: UIViewController {
    func displayError(title: String, message: String) {
        AlertHelper.present(in: self, title: title, message: message)
    }
}
