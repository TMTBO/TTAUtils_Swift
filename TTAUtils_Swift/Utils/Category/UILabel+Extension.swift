//
//  UILabel+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(title: String?, titleColor: UIColor = UIColor.gray, fontSize: CGFloat = 13, numberOfLines: Int = 0, alignment: NSTextAlignment = .left) {
        self.init()
        if let title = title {
            self.text = title
        }
        self.textColor = titleColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
    }
}
