//
//  GlobalFunctions.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 01/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

// Mark: - Debug

func Log<T>(_ message: T..., file: String = #file, line: Int = #line, method: String = #function) {
    #if DEBUG
        print("🕐 \(Date()) \(String((file as NSString).lastPathComponent.characters.dropLast(6))) [line: \(line)], \(method): \(message)")
    #endif
}

// MARK: - Screen

let kSCREEN_SCALE = UIScreen.main.scale
let kSCREEN_BOUNDS = UIScreen.main.bounds
let kSCREEN_WIDTH = UIScreen.main.bounds.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.height
/** 以 4.7 英寸设备为基础换算,布局用比例 */
let kSCALE = (kSCREEN_WIDTH / 375)

// MARK: - Convert Degrees and Radian

func Degrees_TO_Radian(degrees: Double) -> Double {
    return Double.pi * degrees / 180.0
}
func Radian_TO_Degrees(radian: Double) -> Double {
    return 180.0 * radian / Double.pi
}
