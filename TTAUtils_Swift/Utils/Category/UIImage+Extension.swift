//
//  UIImage+Extension.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 02/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

extension TTAUtils where Base: UIImage {
    
    /// 创建一个指定颜色和大小的纯色图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 图片
    class func image(color: UIColor, size: CGSize = CGSize(width: 0.1, height: 0.1)) -> UIImage? {
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
    func image(frame: CGRect, isCircleImage: Bool, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
            if isCircleImage {
                let circlePath = UIBezierPath(ovalIn: frame)
                circlePath.addClip()
            }
            self.base.draw(in: frame)
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
    func normalizedImage() -> UIImage {
        guard base.imageOrientation == UIImageOrientation.up else { return base }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? base
    }
}

// MARK: - QRCode

extension TTAUtils where Base: UIImage {
    struct QRCodeCenterImage {
        var image: UIImage
        var ratio: CGFloat
        
        /// Center image's max ratio.
        /// This is the max recognizable ratio I've ever tried
        private static var maxRatio: CGFloat {
            return 0.35
        }
        
        static private func _validateRatio(_ ratio: CGFloat) -> Bool {
            return ratio <= maxRatio
        }
        
        init(image: UIImage, ratio: CGFloat) {
            self.image = image
            self.ratio = QRCodeCenterImage._validateRatio(ratio) ? ratio : QRCodeCenterImage.maxRatio
        }
    }
    
    /// Creat QRCode with a `Data`
    /// If want a image in the center of the QRCode, pass a `QRCodeCenterImage` instance
    class func createQRCode(_ content: Data?, center image: QRCodeCenterImage? = nil) -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(content, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        guard let ciimage = filter?.outputImage?.applying(CGAffineTransform(scaleX: 10, y: 10)) else { return UIImage() }
        let qrcodeImage = UIImage(ciImage: ciimage)
        guard let centerImage = image else { return qrcodeImage }
        return _drawCenterImage(in: qrcodeImage, center: centerImage)
    }
    
    /// Read a QRCode from a image, then we will get the strings in the image
    /// If there are  more than on QRCode in the image, you will get more than one string
    /// If there are  no QRCode in the image, you will get a nil
    /// So here we got a `[String]?` as the result
    @available(*, deprecated, message: "UIImage Class method deprecated. Use `image.tta.scanQRCode()` instead", renamed: "tta.scanQRCode()")
    class func scanQRCode(_ image: UIImage) -> [String]? {
        //二维码读取
        guard let ciImage = CIImage(image:image) else { return nil }
        let context = CIContext(options: nil)
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]) else { return nil }
        let features = detector.features(in: ciImage)
        guard features.count != 0 else { return nil }
        return features.map { ($0 as!CIQRCodeFeature).messageString ?? "" }
    }
    
    /// Read a QRCode from a image, then we will get the strings in the image
    /// If there are  more than on QRCode in the image, you will get more than one string
    /// If there are  no QRCode in the image, you will get a nil
    /// So here we got a `[String]?` as the result
    func scanQRCode() -> [String]? {
        //二维码读取
        guard let ciImage = CIImage(image:base) else { return nil }
        let context = CIContext(options: nil)
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]) else { return nil }
        let features = detector.features(in: ciImage)
        guard features.count != 0 else { return nil }
        return features.map { ($0 as!CIQRCodeFeature).messageString ?? "" }
    }
    
    class private func _drawCenterImage(in qrcodeImage: UIImage, center image: QRCodeCenterImage) -> UIImage {
        // draw center image
        UIGraphicsBeginImageContextWithOptions(qrcodeImage.size, false, UIScreen.main.scale)
        let size = qrcodeImage.size
        let centerImageSize = CGSize(width: image.ratio * size.width, height: image.ratio * size.height)
        qrcodeImage.draw(in: CGRect(origin: .zero, size: qrcodeImage.size))
        let x = (qrcodeImage.size.width - centerImageSize.width) / 2
        let y = (qrcodeImage.size.height - centerImageSize.height) / 2
        image.image.draw(in: CGRect(origin: CGPoint(x: x, y: y), size: centerImageSize))
        guard let newQRCodeImage = UIGraphicsGetImageFromCurrentImageContext() else { return qrcodeImage }
        UIGraphicsEndImageContext()
        return newQRCodeImage
    }
}

// MARK: - Deprecated
// MARK: -

extension UIImage {
    
    /// 创建一个指定颜色和大小的纯色图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 图片
    @available(*, deprecated, message: "Extessions directly on UIImage are deprecated. Use `image.tta.image` instead", renamed: "ttaClass.image")
    open class func image(color: UIColor, size: CGSize = CGSize(width: 0.1, height: 0.1)) -> UIImage? {
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
    @available(*, deprecated, message: "Extessions directly on UIImage are deprecated. Use `image.tta.image` instead", renamed: "tta.image")
    open func image(frame: CGRect, isCircleImage: Bool, completion: @escaping (UIImage?) -> Void) {
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
    @available(*, deprecated, message: "Extessions directly on UIImage are deprecated. Use `image.tta.normalizedImage` instead", renamed: "tta.normalizedImage")
    open func normalizedImage() -> UIImage {
        guard self.imageOrientation == UIImageOrientation.up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
}
