//
//  NSString+Extension.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

public struct StringProxy {
    fileprivate let base: String
    init(proxy: String) {
        base = proxy
    }
}

extension String: TTAUtilsCompatiable {
    public var tta: StringProxy {
        return StringProxy(proxy: self)
    }
}

extension StringProxy {
    
    /// Convert an object to string value
    ///
    /// - Parameter object: an object
    /// - Returns: string value
    public func string<T>(withObject object: T) -> String? {
        let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let data = objectData else {
            fatalError("Object convert to Data failed : \(object)")
        }
        let string = String(data: data, encoding: String.Encoding.utf8)
        return string
    }
    
    /// Convert a string value to an object
    ///
    /// - Parameter string: a string value
    /// - Returns: an object
    public func object<T>(withString string: String) -> T {
        let stringData = try? JSONSerialization.data(withJSONObject: string, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let data = stringData else {
            fatalError("String convert to Data failed : \(string)")
        }
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? T
        guard let aObject = object, let newObject = aObject else {
            fatalError("Data convert to Object failed")
        }
        return newObject
    }
    
    /// Calculate the width of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the width of the result
    public func width(withFont font: UIFont, containerSize: CGSize) -> CGFloat {
        return size(withFont: font, containerSize: containerSize).width
    }
    
    /// Calculate the height of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the height of the result
    public func height(withFont font: UIFont, containerSize: CGSize) -> CGFloat {
        return size(withFont: font, containerSize: containerSize).height
    }
    
    /// Calculate the size of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the size of the result
    public func size(withFont font: UIFont, containerSize: CGSize) -> CGSize {
        var result = CGSize.zero
        guard !base.isEmpty else { return result }
        result = (base as NSString).boundingRect(with: containerSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        result = CGSize(width: min(containerSize.width, CGFloat(ceilf(Float(result.width)))), height: min(containerSize.height, CGFloat(ceilf(Float(result.height)))))
        return result
    }
}

// MARK: - MD5

extension StringProxy {
    
    /// MD5 string
    var md5: String {
        if let data = base.data(using: .utf8, allowLossyConversion: true) {
            
            let message = data.withUnsafeBytes { bytes -> [UInt8] in
                return Array(UnsafeBufferPointer(start: bytes, count: data.count))
            }
            
            let MD5Calculator = MD5(message)
            let MD5Data = MD5Calculator.calculate()
            
            let MD5String = NSMutableString()
            for c in MD5Data {
                MD5String.appendFormat("%02x", c)
            }
            return MD5String as String
            
        } else {
            return base
        }
    }
}

// MARK: - Deprecated
// MARK: -

extension String {
    
    /// Convert an object to string value
    ///
    /// - Parameter object: an object
    /// - Returns: string value
    @available(*, deprecated, message: "Extessions directly on String are deprecated. Use `string.tta.string(withObject:)` instead", renamed: "tta.string(withObject:)")
    public func string<T>(withObject object: T) -> String? {
        let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let data = objectData else {
            fatalError("Object convert to Data failed : \(object)")
        }
        let string = String(data: data, encoding: String.Encoding.utf8)
        return string
    }
    
    /// Convert a string value to an object
    ///
    /// - Parameter string: a string value
    /// - Returns: an object
    @available(*, deprecated, message: "Extessions directly on String are deprecated. Use `string.tta.object(withString:)` instead", renamed: "tta.object(withString:)")
    public func object<T>(withString string: String) -> T {
        let stringData = try? JSONSerialization.data(withJSONObject: string, options: JSONSerialization.WritingOptions.prettyPrinted)
        guard let data = stringData else {
            fatalError("String convert to Data failed : \(string)")
        }
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? T
        guard let aObject = object, let newObject = aObject else {
            fatalError("Data convert to Object failed")
        }
        return newObject
    }
    
    /// Calculate the width of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the width of the result
    @available(*, deprecated, message: "Extessions directly on String are deprecated. Use `string.tta.width(withFont:containerSize:)` instead", renamed: "tta.width(withFont:containerSize:)")
    public func width(withFont font: UIFont, containerSize: CGSize) -> CGFloat {
        return size(withFont: font, containerSize: containerSize).width
    }
    
    /// Calculate the height of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the height of the result
    @available(*, deprecated, message: "Extessions directly on String are deprecated. Use `string.tta.height(withFont:containerSize:)` instead", renamed: "tta.height(withFont:containerSize:)")
    public func height(withFont font: UIFont, containerSize: CGSize) -> CGFloat {
        return size(withFont: font, containerSize: containerSize).height
    }
    
    /// Calculate the size of a string in a container size
    ///
    /// - Parameters:
    ///   - font: font size
    ///   - containerSize: container size
    /// - Returns: the size of the result
    @available(*, deprecated, message: "Extessions directly on String are deprecated. Use `string.tta.size(withFont:containerSize:)` instead", renamed: "tta.size(withFont:containerSize:)")
    public func size(withFont font: UIFont, containerSize: CGSize) -> CGSize {
        var result = CGSize.zero
        guard !isEmpty else { return result }
        result = (self as NSString).boundingRect(with: containerSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        result = CGSize(width: min(containerSize.width, CGFloat(ceilf(Float(result.width)))), height: min(containerSize.height, CGFloat(ceilf(Float(result.height)))))
        return result
    }
}
