//
//  TTAUtils.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 27/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

public final class TTAUtils<Base> {
    
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has Kingfisher extensions.

public protocol TTAUtilsCompatiable {
    
    associatedtype CompatiableType
    var tta: CompatiableType { get }
    static var ttaClass: CompatiableType.Type { get }
}

public extension TTAUtilsCompatiable {
    
    public var tta: TTAUtils<Self> {
        return TTAUtils(self)
    }
    public static var ttaClass: TTAUtils<Self>.Type {
        return TTAUtils<Self>.self
    }
}

extension NSObject: TTAUtilsCompatiable { }
