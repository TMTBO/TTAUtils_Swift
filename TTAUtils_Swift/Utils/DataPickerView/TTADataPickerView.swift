//
//  TTADataPickerView.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

enum TTADataPickerViewType {
    case text // pickerView default
    case date // datePicker default, date
    case dateTime // date and time
    case time // time
}

class TTADataPickerView: UIView {
    public
    var type: TTADataPickerViewType = .text {
        didSet {
            switch type {
            case .text:
                Log(message: "\(type)")
                guard let picker = pickerView else { return }
                self.addSubview(picker)
            case .date:
                datePicker?.datePickerMode = .date
                guard let picker = datePicker else { return }
                self.addSubview(picker)
            case .dateTime:
                datePicker?.datePickerMode = .dateAndTime
                guard let picker = datePicker else { return }
                self.addSubview(picker)
            case .time:
                datePicker?.datePickerMode = .time
                guard let picker = datePicker else { return }
                self.addSubview(picker)
            }
        }
    }
    
    
    
    
    private lazy var pickerView: UIPickerView? = {
        let toolBarFrame = self.toolBar.frame
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: toolBarFrame.maxY, width: toolBarFrame.width, height: 216))
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    private lazy var datePicker: UIDatePicker? = {
        let toolBarFrame = self.toolBar.frame
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: toolBarFrame.maxY, width: toolBarFrame.width, height: 216))
        datePicker.datePickerMode = .date
        return datePicker
    }()
    private let toolBar: TTADataPickerToolBar = {
        let toolBar = TTADataPickerToolBar()
        return toolBar
    }()
    
    override init(frame: CGRect) {
        var rect = UIScreen.main.bounds
        rect.size.height = 260 // 216 + 44
        super.init(frame: rect)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        var rect = UIScreen.main.bounds
        rect.size.height = 260 // 216 + 44
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public convenience init(title: String, type: TTADataPickerViewType) {
        self.init(frame: CGRect.zero)
        toolBar.titleButton.title = title
        configType(type: type)
    }
    
    private func setupUI() {
        backgroundColor = .white
        // toolbar
        toolBar.barStyle = .default
        toolBar.cancelButton.target = self
        toolBar.cancelButton.action = #selector(didClickCancelButton(button:))
        toolBar.confirmButton.target = self
        toolBar.confirmButton.action = #selector(didClickConfirmButton(button:))
        addSubview(toolBar)
    }
    
    /// the initializer can NOT call the `didSet` and `willSet` method, so we need this function
    private func configType(type: TTADataPickerViewType) {
        self.type = type
    }
}

// MARK: - Actions

extension TTADataPickerView {
    
    @objc fileprivate func didClickCancelButton(button: UIButton) {
        Log(message: "")
    }
    
    @objc fileprivate func didClickConfirmButton(button: UIButton) {
        Log(message: "")
    }
}

extension TTADataPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

    
}
