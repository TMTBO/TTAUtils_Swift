//
//  NSDate+Extension.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 03/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import Foundation

let tta_dateFormatter: DateFormatter = DateFormatter()

let tta_calendar: Calendar = Calendar.current

extension Date {
    ///  将时间字符串转换为日期
    ///
    ///  - parameter dateString: 时间字符串
    ///
    ///  - returns: 日期
    static func stringToDate(dateString: String) -> NSDate {
        tta_dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        tta_dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        return tta_dateFormatter.date(from: dateString)! as NSDate
    }
    
    ///  将日期转换成时间对应的字符串
    ///
    ///  - returns: 要转换成的字符串
    public func dateToString () -> String {
        // 如果是当天
        if tta_calendar.isDateInToday(self) {
            // 计算和当前时间差的秒数
            let seconds = Int(NSDate().timeIntervalSince(self))
            if seconds < 60 { // 小于 1 分钟
                return "刚刚"
            }else if seconds < 60 * 60 { // 小于 1 小时
                return "\(seconds / 60)分钟前"
            }else {// 小于 1 天
                return "\(seconds / 60 / 60)小时前"
            }
        }else {// 不是当天
            var dateFormatString = "HH:mm"
            if tta_calendar.isDateInYesterday(self) {// 是昨天
                dateFormatString = "昨天\(dateFormatString)"
            }else{// 不是昨天
                // 当前年
                let thisYear = tta_calendar.component(.year, from: Date())
                // 时期年
                let dateYear = tta_calendar.component(.year, from: self)
                if thisYear == dateYear {//年份相同
                    dateFormatString = "MM-dd\(dateFormatString)"
                }else{// 年份不同
                    dateFormatString = "yyyy-MM-dd\(dateFormatString)"
                }
            }
            // 将用NSDate转换成需要的字符串
            tta_dateFormatter.dateFormat = dateFormatString
            tta_dateFormatter.locale = Locale(identifier: "en")
            let dateString = tta_dateFormatter.string(from: self)
            return dateString
            
        }
    }
}
