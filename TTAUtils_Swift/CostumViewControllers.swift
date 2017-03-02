//
//  CostumViewControllers.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle
    }
}
