//
//  NSBundle+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import Foundation

let appCurrentVersionKey = "appCurrentVersionKey"

extension TTAUtils where Base: Bundle {
    
    ///  获取当前版本号
    public func getCurrentVersion() -> String {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return currentVersion
    }
    
    ///  保存当前版本号
    public func saveCurrentVersion() {
        let currentVersion = getCurrentVersion()
        UserDefaults.standard.set(currentVersion, forKey: appCurrentVersionKey)
    }
    
    ///  判断是否为新版本
    public func hasNewVersion() -> Bool {
        let currentVersion = getCurrentVersion()
        var hasNewVersion = false
        
        if let oldVersion = UserDefaults.standard.object(forKey: appCurrentVersionKey) {
            hasNewVersion = currentVersion > oldVersion as! String
        } else {
            hasNewVersion = true
        }
        
        saveCurrentVersion()
        
        return hasNewVersion
    }
}

// MARK: - Deprecated
// MARK: - 

extension Bundle {
    
    ///  获取当前版本号
    @available(*, deprecated, message: "Extessions directly on Bundle are deprecated. Use `Bundle.tta.getCurrentVersion()` instead", renamed: "tta.getCurrentVersion()")
    public func getCurrentVersion() -> String {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return currentVersion
    }
    
    ///  保存当前版本号
    @available(*, deprecated, message: "Extessions directly on Bundle are deprecated. Use `Bundle.tta.saveCurrentVersion()` instead", renamed: "tta.saveCurrentVersion()")
    public func saveCurrentVersion() {
        let currentVersion = getCurrentVersion()
        UserDefaults.standard.set(currentVersion, forKey: appCurrentVersionKey)
    }
    
    ///  判断是否为新版本
    @available(*, deprecated, message: "Extessions directly on Bundle are deprecated. Use `Bundle.tta.hasNewVersion()` instead", renamed: "tta.hasNewVersion()")
    public func hasNewVersion() -> Bool {
        let currentVersion = getCurrentVersion()
        var hasNewVersion = false
        
        if let oldVersion = UserDefaults.standard.object(forKey: appCurrentVersionKey) {
            hasNewVersion = currentVersion > oldVersion as! String
        } else {
            hasNewVersion = true
        }
        
        saveCurrentVersion()
        return hasNewVersion
    }
}
