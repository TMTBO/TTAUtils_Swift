//
//  PublicView.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 06/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class PublicView: UIView {

    /// Home Navigation bar search button
    ///
    /// - Parameters:
    ///   - target: target
    ///   - action: action
    /// - Returns: Search button
    public class func homeSearchButton<T>(target: T, action: Selector) -> UIButton {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 44)
        let searchButton = UIButton()
        searchButton.adjustsImageWhenHighlighted = false
        searchButton.setBackgroundImage(UIImage.ttaClass.image(color: UIColor.red, size: rect.size), for: UIControlState.normal)
        searchButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        searchButton.frame = rect
        return searchButton
    }

}
