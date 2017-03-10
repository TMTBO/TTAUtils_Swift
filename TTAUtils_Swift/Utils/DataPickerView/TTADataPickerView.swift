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

@objc protocol TTADataPickerViewDelegate: class, NSObjectProtocol {
    
    @objc optional func dataPickerView(_ pickerView: TTADataPickerView, didSelect titles: [String])
    @objc optional func dataPickerView(_ pickerView: TTADataPickerView, didChange row: Int, inComponent component: Int)
}

class TTADataPickerView: UIView {
    
    // MARK: - Public properties
    weak var delegate: TTADataPickerViewDelegate?
    
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
    internal (set) var textItemsForComponent: [[String]]? {
        didSet {
            pickerView?.reloadAllComponents()
        }
    }
    
    
    // MARK: - Private properties
    fileprivate lazy var pickerView: UIPickerView? = {
        let toolBarFrame = self.toolBar.frame
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: toolBarFrame.maxY, width: toolBarFrame.width, height: 216))
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    fileprivate lazy var datePicker: UIDatePicker? = {
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
    
    convenience init(title: String, type: TTADataPickerViewType) {
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

// MARK: - Public Functions

extension TTADataPickerView {
    
    open func selected(_ titles: [String]?, animated: Bool = true) {
        guard type == .text else { return }
        let totalComponent = min(titles?.count ?? 0, pickerView?.numberOfComponents ?? 0)
        for component in 0..<totalComponent {
            let items = textItemsForComponent?[component]
            guard let title = titles?[component] else { continue }
            guard let _ = items?.contains(title) else { continue }
            guard let row = items?.index(of: title) else { continue }
            pickerView?.selectRow(row, inComponent: component, animated: animated)
        }
    }
}

// MARK: - Private Functions
// MARK: - Actions

extension TTADataPickerView {
    
    @objc fileprivate func didClickCancelButton(button: UIButton) {
        Log(message: "cancel")
    }
    
    @objc fileprivate func didClickConfirmButton(button: UIButton) {
        Log(message: "done")
        switch type {
        case .text:
            guard let componentCount = pickerView?.numberOfComponents else { return }
            var textItems = [String]()
            for component in 0..<componentCount {
                guard let row = pickerView?.selectedRow(inComponent: component), let title = textItemsForComponent?[component][row] else { continue }
                textItems.append(title)
            }
            guard let _ = delegate?.responds(to: #selector(TTADataPickerViewDelegate.dataPickerView(_:didSelect:))) else { break }
            delegate?.dataPickerView?(self, didSelect: textItems)
        case .date, .dateTime, .time:
            Log(message: "date")
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TTADataPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return textItemsForComponent?.count ?? 0
    }

    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let items = textItemsForComponent?[component] else { return 0 }
        return items.count
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let items = textItemsForComponent?[component] else { return nil }
        return items[row]
    }
    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let componentCount = pickerView.numberOfComponents
        for index in 0..<componentCount {
            guard index != component && index > component else { continue }
            pickerView.reloadComponent(index)
            pickerView.selectRow(0, inComponent: index, animated: true)
        }
        
        guard let _ = delegate?.responds(to: #selector(TTADataPickerViewDelegate.dataPickerView(_:didChange:inComponent:))) else { return }
        delegate?.dataPickerView?(self, didChange: row, inComponent: component)
    }
}
