//
//  CostumViewControllers.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    
    /// Custom the view controller GLOBAL
    open func customViewController() {
        view.backgroundColor = kDEFAULT_VIEW_BACKGROUND_COLOR
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.subviews.first?.subviews.first?.isHidden = true // 隐藏导航栏下黑线
    }
    
}

// MARK: - UIViewController Custom Method

extension UIViewController {
    
    /// Add tap gesture for the view controller's root view, to hide the keyboard
    open func addTapBlankToHideKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapBlankToHideKeyboard(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    /// Custom the NavigationBar titleView
    ///
    /// - Parameter titleView: titleView
    open func show(titleView: UIView) {
        self.navigationItem.titleView = titleView
    }
    
    /// Custom the NavigationItem's leftBarButtonItem
    ///
    /// - Parameters:
    ///   - title: item title
    ///   - imageName: item image name, for `.noraml`: imageName , for `.highlighted`: imageName_sel
    open func showLeftItem(title: String?, imageName: String? = nil) {
        self.navigationItem.leftBarButtonItem = creatBarButtonItem(title: title, imageName: imageName, action: #selector(leftItemAction(button:)))
    }
    
    /// Custom the NavigationItem's rightBarButtonItem
    ///
    /// - Parameters:
    ///   - title: item title
    ///   - imageName: item image name, for `.noraml`: imageName , for `.highlighted`: imageName_sel
    open func shwoRightItem(title: String?, imageName: String? = nil) {
        self.navigationItem.rightBarButtonItem = creatBarButtonItem(title: title, imageName: imageName, action: #selector(leftItemAction(button:)))
    }
    
    /// Left NavigationBarItem Action
    ///
    /// - Parameter button: left NavigationBarItem
    open func leftItemAction(button: UIButton) {
        if presentingViewController == nil {
            let _ = navigationController?.popViewController(animated: true)
        } else {
            let _ = dismiss(animated: true
                , completion: nil)
        }
    }
    
    /// Right NavigationBarItem Action
    ///
    /// - Parameter button: right NavigationBarItem
    open func rightItemAction(button: UIButton) {
        // do nothing
        // subclass override this method
    }
    
}

// MARK: - UIViewController Private Method

extension UIViewController {
    
    fileprivate func creatBarButtonItem(title: String?, imageName: String?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: UIButtonType.custom)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        button.tintColor = UIColor.white
        button.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        if let newTitle = title {
            button.setTitle(newTitle, for: UIControlState.normal)
            button.sizeToFit()
        }
        if let imageNameStr = imageName {
            button.setImage(UIImage(named: imageNameStr), for: UIControlState.normal)
            button.setImage(UIImage(named: imageNameStr + "_sel"), for: UIControlState.highlighted)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        let item = UIBarButtonItem(customView: button)
        return item
    }
    
    @objc fileprivate func onTapBlankToHideKeyboard(tap: UITapGestureRecognizer) {
        guard tap.state == UIGestureRecognizerState.ended else { return }
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

// MARK: -
// MARK: - UINavigationController

extension UINavigationController: UINavigationControllerDelegate {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle
    }
}
