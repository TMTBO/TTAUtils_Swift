//
//  MainTabBarController.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

// MARK: - Propreties
class MainTabBarController: UITabBarController {

}

// MARK: - Life Cycle

extension MainTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureTabBarController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private

extension MainTabBarController {
    
    fileprivate func _configureTabBarController() {
        _configure(childViewController: HomeViewController(), title: TTALocalizedString("tabbarHome"), iconImageName: "tabbar_home");
        _configure(childViewController: CategoryViewController(), title: TTALocalizedString("tabbarCategory"), iconImageName: "tabbar_category");
        _configure(childViewController: CartViewController(), title: TTALocalizedString("tabbarCart"), iconImageName: "tabbar_cart");
        _configure(childViewController: MineViewController(), title: TTALocalizedString("tabbarMine"), iconImageName: "tabbar_mine");
    }
    
    fileprivate func _configure(childViewController: UIViewController, title: String, iconImageName: String) {
        childViewController.title = title
        childViewController.tabBarItem.image = UIImage(named: iconImageName)
        childViewController.tabBarItem.selectedImage = UIImage(named: iconImageName + "_sel")
        let navVc = UINavigationController(rootViewController: childViewController)
        addChildViewController(navVc)
    }
}
