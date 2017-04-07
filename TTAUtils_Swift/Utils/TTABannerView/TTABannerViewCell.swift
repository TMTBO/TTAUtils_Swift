//
//  TTABannerViewCell.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 06/04/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class TTABannerViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
}

// MARK: - UI

fileprivate extension TTABannerViewCell {
    
    func setupUI() {
        _addViews()
        _configViews()
        _layoutViews()
    }
    
    func _addViews() {
        contentView.addSubview(imageView)
    }
    
    func _configViews() {
        contentView.backgroundColor = .white
        
    }
    
    func _layoutViews() {
        imageView.frame = contentView.bounds
    }
}
