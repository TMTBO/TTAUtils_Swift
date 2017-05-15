//
//  HudProgressTableViewController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 27/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import TTARefresher

class HudProgressTableViewController: UITableViewController, BaseDataSourceProtocol {

    var groups: [[String]] = [["success", "error", "progress", "image(UIImage?)", "rotatingImage(UIImage?)", "labeledSuccess", "labeledError", "labeledProgress", "labeledImage", "labeledRotatingImage", "label", "systemActivity"]]
    
    deinit {
        Log("\(NSStringFromClass(type(of: self))) deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewController()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        tableView.ttaRefresher.header = TTARefresherNormalHeader {
            Log("pull to refresh")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.tableView.ttaRefresher.header?.endRefreshing()
                self?.tableView.ttaRefresher.footer?.resetNoMoreData()
            })
        }
        tableView.ttaRefresher.footer = TTARefresherBackNormalFooter {
            Log("pull up to refresh")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.tableView.ttaRefresher.footer?.endRefreshWithNoMoreData()
            })

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

// MARK: - UITableViewControllerDataSource

extension HudProgressTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = group(at: section) else { return 0 }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item(at: indexPath)
        return cell
    }
}

extension HudProgressTableViewController {
    
    private enum HUDType: Int {
        case success = 0
        case error
        case progress
        case imageUIImage
        case rotatingImageUIImage
        
        case labeledSuccess
        case labeledError
        case labeledProgress
        case labeledImage
        case labeledRotatingImage
        
        case label
        case systemActivity
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = HUDType(rawValue: indexPath.row) else { return }
        
        switch type {
        case .success:
            TTAHUD.show(.success)
        case .error:
            TTAHUD.show(.error)
        case .progress:
            TTAHUD.show(.progress, dismissAfter: 30)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { 
                TTAHUD.dismiss()
            })
        case .imageUIImage:
            TTAHUD.show(.image(UIImage(named: "login_verification_code")))
        case .rotatingImageUIImage:
            TTAHUD.show(.rotatingImage(UIImage(named: "login_verification_code")))
        case .labeledSuccess:
            TTAHUD.show(.labeledSuccess(title: "Success", subtitle: "really success"))
        case .labeledError:
            TTAHUD.show(.labeledError(title: "Failed", subtitle: "you got it failed"))
        case .labeledProgress:
            TTAHUD.show(.labeledProgress(title: "Progressing", subtitle: "loading"))
        case .labeledImage:
            TTAHUD.show(.labeledImage(image: UIImage(named: "login_verification_code"), title: "Label", subtitle: "subtitle"))
        case .labeledRotatingImage:
            TTAHUD.show(.labeledRotatingImage(image: UIImage(named: "login_verification_code"), title: "Label", subtitle: "subtitle"))
        case .label:
            TTAHUD.show(.label("Label Tip"))
        case .systemActivity:
            TTAHUD.show(.systemActivity)
        }
    }
}
