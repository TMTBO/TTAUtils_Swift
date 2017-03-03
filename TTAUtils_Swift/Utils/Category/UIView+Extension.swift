//
//  UIView+Extension.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

fileprivate struct AssociatedKeys {
    static var tapGestureCompletionHandler = "tapGestureCompletionHandler"
}

// MARK: - Corner

extension UIView {
    
    public func corner(with radius: CGFloat) {
        corner(roundedRect: bounds, cornerRadius: radius)
    }
    
    public func corner(roundedRect rect: CGRect, corners: UIRectCorner = UIRectCorner.allCorners, cornerRadius: CGFloat) {
        corner(roundedRect: rect, corners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    }
    
    public func corner(roundedRect rect: CGRect, corners: UIRectCorner, cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

// MARK: - Gesture

extension UIView {
    
    private var tapGestureCompletionHandler: ((UITapGestureRecognizer) -> Void)? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.tapGestureCompletionHandler) as? (UITapGestureRecognizer) -> Void
        }
        
        set {
            objc_setAssociatedObject(self, AssociatedKeys.tapGestureCompletionHandler, newValue as AnyObject, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func addTapGesture(completionHandler: @escaping (UITapGestureRecognizer) -> Void) {
        tapGestureCompletionHandler = completionHandler
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc private func tapGestureAction(tap: UITapGestureRecognizer) {
        guard let completionHandler = tapGestureCompletionHandler else { return }
        completionHandler(tap)
    }
}
