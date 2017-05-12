//
//  AppDelegate.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    
    override var services: [ApplicationService] {
        return [
            
        ]
    }
     override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         window = _configureWindow()
         _configureCostum()
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
}

// MARK: - Private

extension AppDelegate {
    
    fileprivate func _configureWindow() -> UIWindow {
        let tabbar = MainTabBarController()
        let window = UIWindow()
        window.backgroundColor = .white
        window.rootViewController = tabbar
        window.makeKeyAndVisible()
        return window
    }
    
    fileprivate func _configureCostum() {
        // TabBar
        UITabBar.appearance().tintColor = kDEFAULT_ORANGE_COLOR
        
        // UINavigationBar
        let naviagtionBar = UINavigationBar.appearance()
        naviagtionBar.tintColor = UIColor.white
        naviagtionBar.barTintColor = kDEFAULT_ORANGE_COLOR
        naviagtionBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // UIBarButtonItem
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: CGFloat(Int.min), vertical: CGFloat(Int.max)), for: UIBarMetrics.default)
    }
}

