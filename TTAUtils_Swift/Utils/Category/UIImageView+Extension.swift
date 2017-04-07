//
//  UIImageView+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import Kingfisher

extension TTAUtils where Base: UIImageView {
    
    /// add the sd_webimage or kingfisher code here
    public func setImage(with resource: Resource?,
                         placeholder: Image? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) {
        base.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}

fileprivate extension UIImageView {
    
    /// add the sd_webimage or kingfisher code here
    func setImage(with resource: Resource?,
                         placeholder: Image? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}

extension TTAUtilsManager {
    
    func clearMemoryCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    func clearDiskCache() {
        KingfisherManager.shared.cache.clearDiskCache()
    }
    func clearDiskCache(completion: @escaping () -> ()) {
        KingfisherManager.shared.cache.clearDiskCache(completion: completion)
    }
    func calculateDiskCacheSize(completion handler: @escaping ((_ size: UInt) -> ())) {
        KingfisherManager.shared.cache.calculateDiskCacheSize(completion: handler)
    }
}
