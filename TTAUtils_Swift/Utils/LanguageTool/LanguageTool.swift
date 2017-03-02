//
//  LanguageTool.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

let kAPPLE_LANGUAGE = "AppleLanguages" // 字段对应的值是一个数组

// MARK: - Const

public enum AppLanguages : String {
    case cn = "zh-Hans"
    case en = "en"
}

// MARK: - Function

func TTALocalizedString(_ key: String, comment: String = "") -> String {
    let bundlePath = Bundle.main.path(forResource: getCurrentLanguage(), ofType: "lproj");
    let bundle = Bundle(path: bundlePath!)
    let value = NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: comment)
    return value
}

func getCurrentLanguage() -> String {
    let languages = UserDefaults.standard.object(forKey: kAPPLE_LANGUAGE) as? [String]
    guard let currentLanguage = languages?.first else { return AppLanguages.cn.rawValue }
    return currentLanguage
}

func setNewLanguage(_ newLanguage: AppLanguages) {
    UserDefaults.standard.set([newLanguage.rawValue], forKey: kAPPLE_LANGUAGE)
    UserDefaults.standard.synchronize()
}
