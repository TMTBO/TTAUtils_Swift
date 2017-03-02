//
//  UIColor+Common.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension UIColor {
    public class func random() -> UIColor {
        return UIColor(colorLiteralRed: Float(arc4random_uniform(256)) / 255.0, green: Float(arc4random_uniform(256)) / 255.0, blue: Float(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
    
    public class func hex(hex: UInt32) -> UIColor {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0x00FF00) >> 8
        let blue = (hex & 0x0000FF)
        return UIColor.rgba(red: Float(red), green: Float(green), blue: Float(blue))
    }
    
    public class func rgba(red: Float, green: Float, blue: Float, alpha: Float = 1.0) -> UIColor {
        return UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
