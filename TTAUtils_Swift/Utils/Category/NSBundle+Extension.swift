//
//  NSBundle+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import Foundation

let appCurrentVersionKey = "appCurrentVersionKey"

extension Bundle {
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
