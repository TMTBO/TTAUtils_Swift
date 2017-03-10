//
//  DataPickerViewController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 10/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class DataPickerViewController: UIViewController {
    
    let picker = TTADataPickerView(title: "jhfakdhskjahf", type: .text)
    
    deinit {
        Log(message: "\(NSStringFromClass(type(of: self))) deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - LifeCycle

extension DataPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        custonViewController()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UI

extension DataPickerViewController {
    
    fileprivate func setupUI() {
        view.addSubview(picker)
        
        view.addTapGesture { (_) in
            let titles = self.title?.components(separatedBy: " ")
            self.picker.selected(titles, animated: true)
        }
        
        picker.delegate = self
        picker.textItemsForComponent = [["hello", "hello", "hello", "hello", "hello", "world", "hello"], ["world", "world", "world", "world", "hello", "world", "world"], ["yeah", "ooooh"]]
    }
}

// MARK: - TTADataPickerViewDelegate

extension DataPickerViewController: TTADataPickerViewDelegate {
    
    @objc(dataPickerView:didSelect:)
    internal func dataPickerView(_ pickerView: TTADataPickerView, didSelect titles: [String]) {
        var titleStr = String()
        for str in titles {
            titleStr += str + " "
        }
        title = titleStr
    }

}
