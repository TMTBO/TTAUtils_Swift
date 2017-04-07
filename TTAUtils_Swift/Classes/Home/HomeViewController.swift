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
    var groups = [[String]]()
}

// MARK: - Life Cycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViewController()
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
        show(titleView: PublicView.homeSearchButton(target: self, action: #selector(didClickHomeSearchButton(button:))))
        
        prepareTableView()
        prepareData()
    }
    
    private func prepareTableView() {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
//        tableView.tableHeaderView = BannerView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 200), delegate: nil)
        
        let images = ["http://b.hiphotos.baidu.com/image/h%3D200/sign=38c8f3dbd9a20cf45990f9df46084b0c/d058ccbf6c81800a7892fd52b83533fa828b4772.jpg", "http://b.hiphotos.baidu.com/image/h%3D200/sign=38c8f3dbd9a20cf45990f9df46084b0c/d058ccbf6c81800a7892fd52b83533fa828b4772.jpg", "http://b.hiphotos.baidu.com/image/h%3D200/sign=38c8f3dbd9a20cf45990f9df46084b0c/d058ccbf6c81800a7892fd52b83533fa828b4772.jpg"]
        
//        images = ["login_logo", "login_logo", "login_logo"]
        
        let frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 200)
        
        var bannerView = TTABannerView(frame, imageURLStrings: images, delegate: self)
        let image = UIImage(named: "login_logo")
        bannerView = TTABannerView(frame, placeholderImage: image, delegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            bannerView.imageURLStrings = images
//            bannerView.imageNames = images
        }
        
        tableView.tableHeaderView = bannerView
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCELL_IDENTIFIER)
    }
   
    private func prepareData() {
        groups = [["DataPicker", "TTAWebViewController", "HUD"]]
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc func didClickHomeSearchButton(button: UIButton) {
        Log(#function)
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
        } else if indexPath.row == 1 {
            let avc = TTAWebViewController(url: URL(string: "https://www.baidu.com"))
            avc.canSwipeBack = false
            vc = avc
        } else if indexPath.row == 2 {
            vc = HudProgressTableViewController()
        }
        vc?.title = item(at: indexPath)
        guard let newVc = vc else { return }
        vc?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newVc, animated: true)
    }
}

extension HomeViewController: TTABannerViewDelegate {
    
    func bannerView(_ bannerView: TTABannerView, didSelectItemAt index: Int) {
        Log("Hello world")
    }
}

