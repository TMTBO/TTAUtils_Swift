//
//  UIImage+Extension.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 创建一个指定颜色和大小的纯色图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 图片
    public func image(withColor color: UIColor, size: CGSize = CGSize(width: 0.1, height: 0.1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片异步绘制
    ///
    /// - Parameters:
    ///   - frame: 图片大小
    ///   - isCircleImage: 是否圆形
    ///   - completion: 完成回调
    public func image(frame: CGRect, isCircleImage: Bool, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
            if isCircleImage {
                let circlePath = UIBezierPath(ovalIn: frame)
                circlePath.addClip()
            }
            self.draw(in: frame)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    /// adjust the image orientation
    ///
    /// - Returns: adjusted image
    public func normalizedImage() -> UIImage {
        guard self.imageOrientation == UIImageOrientation.up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
}
