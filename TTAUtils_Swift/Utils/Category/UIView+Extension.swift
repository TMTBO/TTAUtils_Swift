//
//  UIView+Extension.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

// MARK: - Corner

extension TTAUtils where Base: UIView {
    
    public func corner(with radius: CGFloat) {
        corner(roundedRect: base.bounds, cornerRadius: radius)
    }
    
    public func corner(roundedRect rect: CGRect, corners: UIRectCorner = UIRectCorner.allCorners, cornerRadius: CGFloat) {
        corner(roundedRect: rect, corners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    }
    
    public func corner(roundedRect rect: CGRect, corners: UIRectCorner, cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = base.bounds
        maskLayer.path = maskPath.cgPath
        base.layer.mask = maskLayer
    }
}

// MARK: - Gesture

//private var tapGestureAction: UIViewGestureAction?

extension TTAUtils where Base: UIView {
    
    public func addTapGesture(_ target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        base.addGestureRecognizer(tap)
    }

    @available(*, deprecated, message: "Add tap gesture on UIView directly are deprecated. Use `addTapGesture(_:action:)` instead", renamed: "addTapGesture(_:action:)")
    public func addTapGesture(completionHandler: @escaping (UITapGestureRecognizer) -> Void) {
        let tapGestureAction = UIViewGestureAction(tapGestureCompletionHandler: completionHandler)
        let tap = UITapGestureRecognizer(target: tapGestureAction, action: #selector(UIViewGestureAction.tapGestureAction(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        base.addGestureRecognizer(tap)
    }
}

// MARK: - Deprecated
// MARK: -

@available(*, deprecated)
final class UIViewGestureAction {
    
    var tapGestureCompletionHandler: (UITapGestureRecognizer) -> Void
    
    init(tapGestureCompletionHandler: @escaping (UITapGestureRecognizer) -> Void) {
        self.tapGestureCompletionHandler = tapGestureCompletionHandler
    }
    
    @objc fileprivate func tapGestureAction(tap: UITapGestureRecognizer) {
        tapGestureAction(tap: tap)
    }
}

// MARK: - Corner

extension UIView {
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.corner` instead", renamed: "tta.corner")
    public func corner(with radius: CGFloat) {
        corner(roundedRect: bounds, cornerRadius: radius)
    }
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.corner` instead", renamed: "tta.corner")
    public func corner(roundedRect rect: CGRect, corners: UIRectCorner = UIRectCorner.allCorners, cornerRadius: CGFloat) {
        corner(roundedRect: rect, corners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    }
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.corner` instead", renamed: "tta.corner")
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
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.addTapGesture` instead", renamed: "tta.addTapGesture")
    fileprivate struct AssociatedKeys {
        static var tapGestureCompletionHandler = "tapGestureCompletionHandler"
    }
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.addTapGesture` instead", renamed: "tta.addTapGesture")
    private var tapGestureCompletionHandler: ((UITapGestureRecognizer) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureCompletionHandler) as? (UITapGestureRecognizer) -> Void
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureCompletionHandler, newValue as Any, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.addTapGesture` instead", renamed: "tta.addTapGesture")
    public func addTapGesture(completionHandler: @escaping (UITapGestureRecognizer) -> Void) {
        tapGestureCompletionHandler = completionHandler
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
    }
    
    @available(*, deprecated, message: "Extessions directly on UIView are deprecated. Use `view.tta.addTapGesture` instead", renamed: "tta.addTapGesture")
    @objc fileprivate func tapGestureAction(tap: UITapGestureRecognizer) {
        guard let completionHandler = tapGestureCompletionHandler else { return }
        completionHandler(tap)
    }
}
