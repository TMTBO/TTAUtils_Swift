//
//  SelectView.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 10/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

@objc protocol SelectViewDelegate: NSObjectProtocol {
    
    @objc func didSelect(selectView: SelectView)
}

class SelectView: UIView {
    
    internal var actions: [TTAControlEvents : TargetAction]?
    
    weak var delegate: SelectViewDelegate?
    
    fileprivate let tipLabel = UILabel(title: "Hello", titleColor: .darkGray, font: UIFont.systemFont(ofSize: 14), alignment: .left)
    fileprivate let itemLabel = UILabel(title: TTALocalizedString("all"), titleColor: .darkGray, font: UIFont.systemFont(ofSize: 14), alignment: .right)
    fileprivate let iconImageView = UIImageView(image: UIImage.ttaClass.image(color: .darkGray, size: CGSize(width: 10, height: 10)))
    
    fileprivate var selectItems = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    convenience init(tip: String?, current item: String, selectFrom items: [String]) {
        self.init(frame: .zero)
        tipLabel.text = tip
        itemLabel.text = item
        configSelectedItem(item: item)
        configSelectItems(items: items)
    }
    
    private func configSelectItems(items: [String]) {
        selectItems = items
    }

}

// MARK: - Public Functions
extension SelectView {
    
    open func configSelectedItem(item: String) {
        itemLabel.text = item
    }
}

// MARK: - UI

extension SelectView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15 * kSCALE)
            make.centerY.equalTo(self)
            make.width.equalTo(tipLabel.text?.tta.width(withFont: tipLabel.font, containerSize: CGSize(width: 150, height: 30)) ?? 150)
        }
    }
    
    fileprivate func setupUI() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0 / kSCREEN_SCALE
        _addViews()
        _configViews()
        _layoutViews()
    }
    
    private func _addViews() {
        addSubview(tipLabel)
        addSubview(itemLabel)
        addSubview(iconImageView)
    }
    
    private func _configViews() {
        tta.addTapGesture(self, action: #selector(tapGesture(tap:)))
    }
    
    private func _layoutViews() {
        itemLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(tipLabel.snp.trailing).offset(15 * kSCALE)
            make.centerY.equalTo(tipLabel)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(itemLabel.snp.trailing).offset(15 * kSCALE)
            make.trailing.equalToSuperview().offset(-15 * kSCALE)
            make.centerY.equalTo(tipLabel)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }
}

extension SelectView {
    @objc func tapGesture(tap: UITapGestureRecognizer) {
        self.delegate?.didSelect(selectView: self)
    }
}
