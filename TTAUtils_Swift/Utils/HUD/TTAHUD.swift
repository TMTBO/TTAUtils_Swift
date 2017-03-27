//
//  TTAHUD.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 27/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import PKHUD

typealias TTAHUDContentType = HUDContentType

struct TTAHUD {
    
    // MARK: Properties
    public static var dimsBackground: Bool {
        get { return PKHUD.sharedHUD.dimsBackground }
        set { PKHUD.sharedHUD.dimsBackground = newValue }
    }
    
    public static var allowsInteraction: Bool {
        get { return PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled  }
        set { PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }
    
    public static var isVisible: Bool { return PKHUD.sharedHUD.isVisible }
    
    public static func show(_ type: TTAHUDContentType, onView view: UIView? = nil, dismissAfter delayTime: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        HUD.show(type , onView: view)
        HUD.hide(afterDelay: delayTime, completion: completion)
    }
    
    public static func dismiss(afterDelay delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(afterDelay: delay, completion: completion)
    }
}
