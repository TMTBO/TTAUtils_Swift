//
//  UIScrollView+BottomRefreshController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 15/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

fileprivate struct NotificationKeys {
    static var refreshControlEndRefreshingNotification = "refreshControlEndRefreshingNotification"
}

fileprivate struct PrivateConst {
    static var minRefreshTime: TimeInterval = 0.5
}

// MARK: - Swizzling Method

extension NSObject {
    
    class fileprivate func tta_swizzleMethod(origSelector: Selector, with newSelector: Selector) {
        let origMethod = class_getInstanceMethod(self, origSelector)
        let newMethod = class_getInstanceMethod(self, newSelector)
        
        let isSuccess = class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
        if isSuccess {
            class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
        }
        method_exchangeImplementations(origMethod, newMethod)
    }

}

// MARK: - FindSubView

extension UIView {
    
    fileprivate func tta_findFirstSubviewPassingTest(predicate: (UIView) -> Bool) -> UIView? {
        if predicate(self) {
            return self
        } else {
            for subView in subviews {
                let result = subView.tta_findFirstSubviewPassingTest(predicate: predicate)
                if result !== nil {
                    return result
                }
            }
        }
        return nil
    }
    
}

// MARK: - BottomRefreshControl

extension UIRefreshControl {
    
    open var triggerVerticalOffset: Float {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.triggerVerticalOffset) as? Float ?? 120
        }
        set {
            assert(newValue > 0)
            objc_setAssociatedObject(self, &AssociatedKeys.triggerVerticalOffset, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private struct AssociatedKeys {
        static var manualEndRefreshing = "manualEndRefreshing"
        static var triggerVerticalOffset = "triggerVerticalOffset"
    }
    
    fileprivate var tta_manualEndRefreshing: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.manualEndRefreshing) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.manualEndRefreshing, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    override open class func initialize() {
        if self != UIRefreshControl.self {
            return
        }
        tta_swizzleMethod(origSelector: #selector(endRefreshing), with: #selector(tta_endRefreshing))
    }
    
    @objc fileprivate func tta_endRefreshing() {
        if tta_manualEndRefreshing {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.refreshControlEndRefreshingNotification), object: self)
        } else {
            tta_endRefreshing()
        }
    }
    
    fileprivate func tta_titleLabel() -> UILabel? {
        let label = tta_findFirstSubviewPassingTest { (subView) -> Bool in
            guard let label = subView as? UILabel, label.attributedText == attributedTitle else { return false }
            return true
        }
        return label as? UILabel
    }
    
}

//MARK: - TTAContext

internal class TTAContext {
    
    var refreshed = false
    var adjustBottomInset = false
    var wasTracking = false
    var beginRefreshingDate: Date?
    
    weak var fakeTableView: UITableView?
}

// MARK: - BottomRefreshControl

extension UIScrollView {
    
    open var bottomRefreshControl: UIRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bottomRefreshControlKey) as? UIRefreshControl
        }
        set {
            if let _ = self.bottomRefreshControl {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKeys.refreshControlEndRefreshingNotification), object: self.bottomRefreshControl)
                self.bottomRefreshControl?.tta_manualEndRefreshing = false
                self.bottomRefreshControl?.tta_titleLabel()?.transform = .identity
            }
            
            if let refresh = newValue {
                let context = TTAContext()
                self.tta_context = context
                
                let tableView = UITableView(frame: .zero, style: .plain)
                tableView.isUserInteractionEnabled = false
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.backgroundColor = .clear
                tableView.separatorStyle = .none
                tableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                
                refresh.tta_manualEndRefreshing = true
                NotificationCenter.default.addObserver(self, selector: #selector(tta_didEndRefreshing), name: NSNotification.Name(rawValue: NotificationKeys.refreshControlEndRefreshingNotification), object: refresh)
                
                refresh.tta_titleLabel()?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                
                tableView.addSubview(refresh)
                context.fakeTableView = tableView
                
//                if superview != nil {
                    tta_insertFakeTableView()
//                }
            }
            willChangeValue(forKey: "bottomRefreshControl")
            objc_setAssociatedObject(self, &AssociatedKeys.bottomRefreshControlKey, newValue as Any, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "bottomRefreshControl")
        }
    }
    
    private struct AssociatedKeys {
        static var contextKey = "contextKey"
        static var bottomRefreshControlKey = "bottomRefreshControlKey"
    }
    
    private struct Default {
        static var triggerRefresgVeriticalOffset: CGFloat = 120.0
    }
    
    internal var tta_context: TTAContext? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.contextKey) as? TTAContext
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.contextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
//    @objc private var tta_contentInset: UIEdgeInsets {
//        get  {
//            var insets = self.tta_contentInset
//            if tta_adjustBottomInset() {
//                insets.bottom -= self.bottomRefreshControl?.frame.size.height ?? 0
//            }
//            return insets
//        }
//        set {
//            
//        }
//    }
    
    override open class func initialize() {
        tta_swizzleMethod(origSelector: #selector(didMoveToSuperview), with: #selector(tta_didMoveToSuperview))
        tta_swizzleMethod(origSelector: #selector(setter: contentInset), with: #selector(tta_setContentInset(insets:)))
        tta_swizzleMethod(origSelector: #selector(getter: contentInset), with: #selector(tta_contentInset))
        tta_swizzleMethod(origSelector: #selector(setter: contentOffset), with: #selector(tta_setContentOffset(contentOffset:)))
    }
    
    
    @objc private func tta_didMoveToSuperview() {
        tta_didMoveToSuperview()
        guard let _ = tta_context else { return }
        if superview != nil {
            tta_insertFakeTableView()
        } else {
            tta_context?.fakeTableView?.removeFromSuperview()
        }
    }
    @objc private func tta_contentInset() -> UIEdgeInsets {
        var insets = self.tta_contentInset()
        if tta_adjustBottomInset() {
            insets.bottom -= self.bottomRefreshControl?.frame.size.height ?? 0
        }
        return insets
    }
    @objc private func tta_setContentInset(insets: UIEdgeInsets) {
        var insets = insets
        if tta_adjustBottomInset() {
            insets.bottom += bottomRefreshControl?.frame.size.height ?? 0
        }
        self.tta_setContentInset(insets: insets)
        setNeedsUpdateConstraints()
    }
    
    
    @objc private func tta_setContentOffset(contentOffset: CGPoint) {
        tta_setContentOffset(contentOffset: contentOffset)
        guard let context = tta_context else { return }
        if context.wasTracking && !self.isTracking {
            didEndTracking()
        }
        context.wasTracking = isTracking
        let contentInset = self.contentInset
        let height = frame.size.height
        
        let offset = (contentOffset.y + contentInset.top + height) - max(self.contentSize.height + contentInset.bottom + contentInset.top, height)
        
        if offset > 0 {
            handleBottonBounceOffset(offset: offset)
        } else {
            context.refreshed = false
        }
        self.tta_context = context
    }
    
    internal func tta_chechRefreshingTimeAndPerformHandler(handler: @escaping () -> Void) {
        if let date = tta_context?.beginRefreshingDate {
            let timeSinceLastRefresh = Date().timeIntervalSince(date)
            if timeSinceLastRefresh > PrivateConst.minRefreshTime {
                handler()
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + PrivateConst.minRefreshTime, execute: handler)
            }
        } else {
            handler()
        }
        
    }
    
    private func tta_insertFakeTableView() {
        guard let tableView = tta_context?.fakeTableView else { return }
        if superview == nil {
            addSubview(tableView)
            
            // autolayout
            let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -contentInset.bottom)
            let height = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Default.triggerRefresgVeriticalOffset)
            tableView.addConstraint(height)
            addConstraints([left, right, bottom])
            
        } else {
            superview?.insertSubview(tableView, aboveSubview: self)
            
            // autolayout
            let left = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -contentInset.bottom)
            let height = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Default.triggerRefresgVeriticalOffset)
            tableView.addConstraint(height)
            superview?.addConstraints([left, right, bottom])
        }
    }
    
    private func tta_adjustBottomInset() -> Bool {
        return tta_context?.adjustBottomInset ?? false
    }
    private func tta_setAdjustBottomInset(_ adjust: Bool, animated: Bool) {
        let contentInset = self.contentInset
        tta_context?.adjustBottomInset = adjust
        if animated {
            UIView.beginAnimations(nil, context: nil)
        }
        self.contentInset = contentInset
        if animated {
            UIView.commitAnimations()
        }
    }
    
    private func handleBottonBounceOffset(offset: CGFloat) {
        var contentOffset = tta_context?.fakeTableView?.contentOffset
        let triggerOffset = bottomRefreshControl?.triggerVerticalOffset
        
        if !(tta_context?.refreshed ?? false) && (!isDecelerating || (contentOffset?.y ?? 0 < CGFloat(0))) {
            if offset < CGFloat(triggerOffset!) {
                contentOffset?.y = -offset * Default.triggerRefresgVeriticalOffset / CGFloat(triggerOffset!) / 1.5
                tta_context?.fakeTableView?.contentOffset = contentOffset ?? .zero
            } else if !(bottomRefreshControl?.isRefreshing)! {
                tta_startRefresh()
            }
        }
    }
    
    @objc private func tta_didEndRefreshing() {
        tta_chechRefreshingTimeAndPerformHandler {
            self.bottomRefreshControl?.tta_endRefreshing()
            self.tta_stopRefresh()
        }
    }
    
    private func tta_startRefresh() {
        tta_context?.beginRefreshingDate = Date()
        
        bottomRefreshControl?.beginRefreshing()
        bottomRefreshControl?.sendActions(for: .valueChanged)
        
        if !isTracking && !tta_adjustBottomInset() {
            tta_setAdjustBottomInset(true, animated: true)
        }
    }
    
    private func tta_stopRefresh() {
        tta_context?.wasTracking = isTracking
        if !isTracking && tta_adjustBottomInset() {
            DispatchQueue.main.async {
                self.tta_setAdjustBottomInset(false, animated: true)
            }
        }
    }
    
    
    private func didEndTracking() {
        if let refreshing = bottomRefreshControl?.isRefreshing, refreshing && !tta_adjustBottomInset() {
            tta_setAdjustBottomInset(true, animated: true)
        }
        if let refreshing = bottomRefreshControl?.isRefreshing, !refreshing && tta_adjustBottomInset() {
            tta_setAdjustBottomInset(false, animated: true)
        }
    }
}

//// MARK: - BottomRefreshControl
//
//extension UITableView {
//    override open class func initialize() {
//        tta_swizzleMethod(origSelector: #selector(reloadData), with: #selector(tta_reloadData))
//    }
//    
//    @objc private func tta_reloadData() {
//        if tta_context == nil {
//            tta_reloadData()
//        } else {
//            tta_chechRefreshingTimeAndPerformHandler {
//                self.tta_reloadData()
//            }
//        }
//    }
//}
//
//// MARK: - BottomRefreshControl
//
//extension UICollectionView {
//    override open class func initialize() {
//        tta_swizzleMethod(origSelector: #selector(reloadData), with: #selector(tta_reloadData))
//    }
//    
//    @objc private func tta_reloadData() {
//        if tta_context == nil {
//            tta_reloadData()
//        } else {
//            tta_chechRefreshingTimeAndPerformHandler {
//                self.tta_reloadData()
//            }
//        }
//    }
//}

