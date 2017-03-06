//
//  HomeViewController.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    let picker = TTADataPickerView(title: "jhfakdhskjahf", type: .date)

}

// MARK: - Life Cycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custonViewController()
        setupUI()
        
        view.addTapGesture { (_) in
            //            let vc = CategoryViewController()
            //            vc.hidesBottomBarWhenPushed = true
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6) {
            self.scrollViewDidScroll(self.tableView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.subviews.first?.alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: - UI

extension HomeViewController {
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.subviews.first?.alpha = 0.0
        
//        show(titleView: PublicView.homeSearchButton(target: self, action: #selector(didClickHomeSearchButton(button:))))
    }
    
    
}

// MARK: - Actions

extension HomeViewController {
    @objc func didClickHomeSearchButton(button: UIButton) {
        Log(message: #function)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let alpha = offset / 150.0
        navigationController?.navigationBar.subviews.first?.alpha = alpha
    }
    
}

