//
//  UIButton+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String?, titleColor: UIColor = UIColor.darkGray, imageName: String? = nil, backgroundImageName: String? = nil, fontSize: CGFloat = 13, target: AnyObject? = nil, action: String? = nil, event: UIControlEvents = .touchUpInside){
        self.init()
        if let title = title {
            self.setTitle(title, for: .normal)
            self.setTitleColor(titleColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        
        if let imageName = imageName  {
            self.setImage(UIImage(named: imageName), for: .normal)
            self.setImage(UIImage(named: "\(imageName)_selected"), for: .highlighted)
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
