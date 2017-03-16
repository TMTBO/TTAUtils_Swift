//
//  HomeViewController.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

let kCELL_IDENTIFIER = "cellIdentifier"

class HomeViewController: UITableViewController, BaseDataSourceProtocol {
    typealias T = String
    var groups = [[T]]()

//    let refresh = UIRefreshControl()
}

// MARK: - Life Cycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custonViewController()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6) {
            self.scrollViewDidScroll(self.tableView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.subviews.first?.alpha = 1.0
        }
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
        view.backgroundColor = .white
        title = nil
        show(titleView: PublicView.homeSearchButton(target: self, action: #selector(didClickHomeSearchButton(button:))))
        
        prepareTableView()
        prepareData()
    }
    
    private func prepareTableView() {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        tableView.tableHeaderView = BannerView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 200), delegate: nil)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCELL_IDENTIFIER)
    }
   
    private func prepareData() {
        groups = [["DataPicker"]]
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc func didClickHomeSearchButton(button: UIButton) {
        Log(message: #function)
    }
    
}

// MARK: - UITableViewDataSource

extension HomeViewController {
    
    override internal func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = group(at: section) else { return 0 }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCELL_IDENTIFIER, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = item(at: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let alpha = offset / 150.0
        navigationController?.navigationBar.subviews.first?.alpha = alpha
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc: UIViewController?
        if indexPath.row == 0 {
            vc = DataPickerViewController()
        }
        guard let newVc = vc else { return }
        vc?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newVc, animated: true)
    }
}

