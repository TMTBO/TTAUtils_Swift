//
//  CategoryViewController.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {


}

// MARK: - Life Cycle

extension CategoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testFunctions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// test
extension CategoryViewController {
    
    func testFunctions() {
        testUIButtonLayoutType()
    }
    
    private func testUIButtonLayoutType() {
        let button = UIButton(title: "Hello world")
        button.setBackgroundImage(UIImage.image(color: .orange), for: .normal)
        button.setImage(UIImage.image(color: .red, size: CGSize(width: 50, height: 50)), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = view.center
        button.tag = 0
        button.addTarget(self, action: #selector(didClickButton(button:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func didClickButton(button: UIButton) {
        var tag = button.tag
        tag += 1
        button.tag = tag > 7 ? 0 : tag
        button.layoutType = UIButtonLayoutType(rawValue: tag) ?? .default
        button.layoutTypePadding = CGFloat(button.layoutTypePadding) + CGFloat(5)
//        button.setLayoutType(type: UIButtonLayoutType(rawValue: tag) ?? .default, padding: 20)
    }
    
}
