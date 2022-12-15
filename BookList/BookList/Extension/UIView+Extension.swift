//
//  UIView+Extension.swift
//  BookList
//
//  Created by Dileep Nair on 12/15/22.
//

import UIKit

/// UIView extension
extension UIView {
    /// Add rounded corners to the view
    /// - Parameters:
    ///   - corners: UIRectCorner value
    ///   - cornerRadius: Double value
    func round(corners: UIRectCorner, cornerRadius: Double) {
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
