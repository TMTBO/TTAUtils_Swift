//
//  UIButton+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/ 2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

/// Custom Layout UIButton
///
/// - `default`: Default Layout
/// - imageRightTitleLeft: Image on the right, and title on the left, align centre, margin is paddig
/// - imageTopTitleBottom: Image on the top, and title on the bottom, align centre, margin is paddig
/// - imageBottomTitleTop: Image on the bottom, and title on the top, align centre, margin is paddig
/// - imageCenterTitleTop: Image on the button right center, and title on the top of the image, margin is paddig
/// - imageCenterTitleBottom: Image on the button right center, and title on the bottom of the image, margin is paddig
/// - imageCenterTitleTopToButton: Image on the button right center, and title on the top of the image, margin to the button top is paddig
/// - imageCenterTitleBottomToButton: Image on the button right center, and title on the bottom of the image, margin to the button bottom is paddig
public enum UIButtonLayoutType: Int {
    case `default`
    case imageRightTitleLeft
    case imageTopTitleBottom
    case imageBottomTitleTop
    case imageCenterTitleTop
    case imageCenterTitleBottom
    case imageCenterTitleTopToButton
    case imageCenterTitleBottomToButton

}

private struct AssociateKey {
    static var layoutType = "UIButtonLayoutType"
    static var layoutTypePadding = "UIButtonLayoutTypePadding"
}

extension UIButton {
    
    convenience init(title: String?, titleColor: UIColor = UIColor.darkGray, imageName: String? = nil, backgroundImageName: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 14), target: AnyObject? = nil, action: String? = nil, event: UIControlEvents = .touchUpInside){
        self.init()
        if let title = title {
            self.setTitle(title, for: .normal)
            self.setTitleColor(titleColor, for: .normal)
            self.titleLabel?.font = font
        }
        
        if let imageName = imageName  {
            self.setImage(UIImage(named: imageName), for: .normal)
            self.setImage(UIImage(named: "\(imageName)_sel"), for: .highlighted)
        }
        
        if let backgroundImageName = backgroundImageName {
            self.setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
            self.setBackgroundImage(UIImage(named: backgroundImageName), for: .highlighted)
        }
        if let target = target, let action = action {
            let selector = Selector(action)
            self.addTarget(target, action: selector, for: event)
        }
        
        self.sizeToFit()
    }
}

// MARK: - CustomLayout

fileprivate var kLayoutType: UIButtonLayoutType = .default
fileprivate var kLayoutTypePadding : CGFloat = 0

extension UIButton {
    
    /// Custom UIButtonLayoutType
    open var layoutType: UIButtonLayoutType {
        get {
            return kLayoutType
        }
        set {
            setLayoutType(type: newValue, padding: self.layoutTypePadding)
        }
    }
    
    /// Custom UIButtonLayoutType padding
    open var layoutTypePadding: CGFloat {
        get {
            return kLayoutTypePadding
        }
        set {
            setLayoutType(type: self.layoutType, padding: newValue)
        }
    }
    
    /// Set custom UIButtonLayoutType and padding
    ///
    /// - Parameters:
    ///   - type: layout type
    ///   - padding: padding
    open func setLayoutType(type: UIButtonLayoutType, padding: CGFloat = 0.0) {

        kLayoutType = type
        kLayoutTypePadding = padding
        
        titleEdgeInsets = UIEdgeInsets.zero
        imageEdgeInsets = UIEdgeInsets.zero
        
        let imageRect = (imageView?.frame)!
        let titleRect = (titleLabel?.frame)!
        
        let totalHeight = imageRect.size.height + padding + titleRect.size.height
        let selfHeight = frame.size.height;
        let selfWidth = frame.size.width;
        
        switch type {
        case .default:
            if (padding != 0) {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding / 2, 0, -padding / 2);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding / 2, 0, padding / 2);
            }
        case .imageRightTitleLeft:
            //图片在右，文字在左
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageRect.size.width + padding / 2), 0, (imageRect.size.width + padding / 2));
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (titleRect.size.width + padding / 2), 0, -(titleRect.size.width + padding / 2));
        case .imageTopTitleBottom:
            //图片在上，文字在下
            self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y), (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, -((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y), -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 - imageRect.origin.y), (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), -((selfHeight - totalHeight) / 2 - imageRect.origin.y), -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        case .imageBottomTitleTop:
            //图片在下，文字在上。
            self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 - titleRect.origin.y), (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, -((selfHeight - totalHeight) / 2 - titleRect.origin.y), -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y), (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y), -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        case .imageCenterTitleTop:
            self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y - padding), (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, (titleRect.origin.y - padding), -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        case .imageCenterTitleBottom:
            self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight - padding - titleRect.origin.y - titleRect.size.height), (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, -(selfHeight - padding - titleRect.origin.y - titleRect.size.height), -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        case .imageCenterTitleTopToButton:
            self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding), (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding), -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        case .imageCenterTitleBottomToButton:
            self.titleEdgeInsets = UIEdgeInsetsMake((imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding), (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding), -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
        }
    }
    
}
