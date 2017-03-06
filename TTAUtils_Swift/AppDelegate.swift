//
//  AppDelegate.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _configureWindow()
        _configureCostum()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - Private

extension AppDelegate {
    fileprivate func _configureWindow() {
        let tabbar = MainTabBarController()
        window = UIWindow()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
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

