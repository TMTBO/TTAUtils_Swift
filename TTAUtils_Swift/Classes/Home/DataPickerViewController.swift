//
//  DataPickerViewController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 10/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import TTADataPickerView

class DataPickerViewController: UIViewController {
    
    let picker = TTADataPickerView(title: "jhfakdhskjahf", type: .dateTime, delegate: nil)
    
    deinit {
        Log("\(NSStringFromClass(type(of: self))) deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - LifeCycle

extension DataPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViewController()
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
//        view.addSubview(picker)
        
        view.tta.addTapGesture(self, action: #selector(tapGesture(tap:)))
        TTADataPickerView.appearance().setConfirmButtonAttributes(att: [NSForegroundColorAttributeName: UIColor.blue])
        TTADataPickerView.appearance().setCancelButtonAttributes(att: [NSForegroundColorAttributeName: UIColor.red])
        TTADataPickerView.appearance().setToolBarTintColor(color: .orange)
        TTADataPickerView.appearance().setToolBarBarTintColor(color: .cyan)
        
        picker.type = .date
        picker.delegate = self
        picker.textItemsForComponent = [["hello", "hello", "hello", "hello", "hello", "world", "hello"], ["world", "world", "world", "world", "hello", "world", "world"], ["yeah", "ooooh"]]
    }
}

// MARK: - Action

extension DataPickerViewController {
    @objc func tapGesture(tap: UITapGestureRecognizer) {
        if self.picker.type == .text {
            let titles = self.title?.components(separatedBy: " ")
            self.picker.selectedTitles(titles, animated: true)
        } else {
            self.picker.selectedDate(Date())
        }
        self.picker.show()
    }
}

// MARK: - TTADataPickerViewDelegate

extension DataPickerViewController: TTADataPickerViewDelegate {
    
    func dataPickerView(_ pickerView: TTADataPickerView, didSelectTitles titles: [String]) {
        title = titles.joined(separator: " ")
    }
    
    internal func dataPickerView(_ pickerView: TTADataPickerView, didSelectDate date: Date) {
        tta_dateFormatter.timeStyle = .none
        title = tta_dateFormatter.string(from: date)
    }

}
