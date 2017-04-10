//
//  TTAQRCoderScanViewController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 10/04/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import AVFoundation

class TTAQRCodeScanViewController: UIViewController {
    
    struct TTAQRCodeScanViewControllerConst {
        static let notFoundTip = "没有发现二维码/条形码"
        static let scanTip = "将二维码/条形码放入框内,即可自动扫描"
        static let turnOnFlashLightTip = "点击打开灯光"
        static let turnOffFlashLightTip = "点击关闭灯光"
        static let errorTip = "提醒"
        static let errorMessage = "请在手机的\"设置-隐私-相机\"选项中,允许本程序访问您的相机"
        static let confirm = "确定"
        static let imagePickerTip = "相册"
    }
    
    /// 获取到二维码/条形码信息后的结果处理
    var qrCodeScanResultHandler: ((String) -> ())?
    
    fileprivate let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    fileprivate let captureSession = AVCaptureSession()
    
    fileprivate let overlayView = UIView()
    fileprivate let scanLineImageView = UIImageView()
    /// 扫描框下方提示
    fileprivate let tipLabel = UILabel()
    /// 灯光按钮
    fileprivate let flashlightButton = UIButton()
    /// 相册选择按钮
    fileprivate let imagePickerButton = UIButton()
    fileprivate let imagePicker = UIImagePickerController()
    /// 灯光开关状态
    fileprivate var isTouchOn = false
    /// 是否检测到二维码或者条形码
    fileprivate var hasCode = true
    
    deinit {
        Log("\(NSStringFromClass(type(of: self))) deinit")
    }
}

// MARK: - LifeCycle

extension TTAQRCodeScanViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        _scanQRCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _startAnimation()
        tipLabel.text = TTAQRCodeScanViewControllerConst.scanTip
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _removeAnimation()
        guard isTouchOn else { return }
        _turnOffFlashLight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipLabel.sizeToFit()
        imagePickerButton.sizeToFit()
        imagePickerButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 80)
    }
}

fileprivate extension TTAQRCodeScanViewController {
    
    func _scanQRCode() {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            
            // 检测光线强度
            let lightOutput  = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(lightOutput) {
                lightOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
                captureSession.addOutput(lightOutput)
            }
            
            guard captureSession.canAddInput(input) else { return }
            captureSession.addInput(input)
            
            guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            guard captureSession.canAddOutput(output) else { return }
            captureSession.addOutput(output)
            
            output.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeCode39Mod43Code,
                                          AVMetadataObjectTypeCode93Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeAztecCode,
                                          AVMetadataObjectTypePDF417Code,
                                          AVMetadataObjectTypeQRCode]
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width:windowSize.width * 3 / 4, height:windowSize.width * 3 / 4)
            let scanRect = CGRect(x:(windowSize.width - scanSize.width) / 2,
                                  y:(windowSize.height - scanSize.height) / 2,
                                  width:scanSize.width, height:scanSize.height)
            let rectInterest = CGRect(x:scanRect.origin.y / windowSize.height,
                              y:scanRect.origin.x / windowSize.width,
                              width:scanRect.size.height / windowSize.height,
                              height:scanRect.size.width / windowSize.width);
            output.rectOfInterest = rectInterest
            
            _setOverlayView(scanRect)
            
            captureSession.startRunning()
            
        } catch {
            //打印错误消息
            let alertController = UIAlertController(title: TTAQRCodeScanViewControllerConst.errorTip,
                                                    message: TTAQRCodeScanViewControllerConst.errorMessage,
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: TTAQRCodeScanViewControllerConst.confirm, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func _setOverlayView(_ scanRect: CGRect) {
        overlayView.frame = UIScreen.main.bounds
        overlayView.alpha = 0.5
        overlayView.backgroundColor = .black
        view.addSubview(overlayView)
        
        let scanRectangleImageView = UIImageView(frame: scanRect)
        scanRectangleImageView.image = UIImage(named: "scanRectangle")
        view.addSubview(scanRectangleImageView)
        
        _resetMaskView(scanRect)
        
        scanLineImageView.frame = CGRect(x: 0, y: 0, width: scanRect.width, height: 6 / UIScreen.main.scale)
        scanLineImageView.image = UIImage(named: "scanLine")
        scanLineImageView.contentMode = .scaleAspectFill
        scanLineImageView.backgroundColor = .clear
        scanRectangleImageView.addSubview(scanLineImageView)
        
        tipLabel.text = TTAQRCodeScanViewControllerConst.scanTip
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 16.0)
        tipLabel.textAlignment = .center
        tipLabel.sizeToFit()
        tipLabel.center = CGPoint(x: scanRectangleImageView.center.x, y: scanRectangleImageView.frame.maxY + 30)
        view.addSubview(tipLabel)
        
        flashlightButton.frame = CGRect(x: scanRect.origin.x, y: scanRect.height * 3 / 4 + scanRect.origin.y, width: scanRect.width, height: scanRect.height / 4)
        flashlightButton.addTarget(self, action: #selector(_exchangeFlashlight), for: .touchUpInside)
        flashlightButton.setImage(UIImage(named: "flashlight_off"), for: .normal)
        flashlightButton.setImage(UIImage(named: "flashlight_on"), for: .selected)
        flashlightButton.contentMode = .center
        flashlightButton.backgroundColor = .clear
        flashlightButton.isHidden = true
        view.addSubview(flashlightButton)
        
        imagePickerButton.setTitle(TTAQRCodeScanViewControllerConst.imagePickerTip, for: .normal)
        imagePickerButton.adjustsImageWhenHighlighted = false
        imagePickerButton.addTarget(self, action: #selector(_didClickImagePicker(button:)), for: .touchUpInside)
        imagePickerButton.setTitleColor(.green, for: .normal)
        imagePickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(imagePickerButton)
    }
    
    func _resetMaskView(_ maskRect: CGRect){
        let path = UIBezierPath(rect: overlayView.bounds)
        let maskOffset = 6 / UIScreen.main.scale
        let clearPath = UIBezierPath(rect: CGRect(x: maskRect.minX + maskOffset, y: maskRect.minY + maskOffset, width: maskRect.width - 2 * maskOffset, height: maskRect.height - 2 * maskOffset)).reversing()
        path.append(clearPath)
        if let shapeLayer = overlayView.layer.mask as? CAShapeLayer {
            shapeLayer.path = path.cgPath
        }else{
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            overlayView.layer.mask = shapeLayer
            shapeLayer.path = path.cgPath
        }
    }
    
    @objc func _didClickImagePicker(button: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Animations

fileprivate extension TTAQRCodeScanViewController {
    func _startAnimation(){
        scanLineImageView.isHidden = false
        let animation = CABasicAnimation(keyPath: "position")
        let width = UIScreen.main.bounds.width * 3 / 4
        animation.fromValue = NSValue(cgPoint: CGPoint(x: width / 2, y: 0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: width / 2, y: width))
        animation.duration = 2.0
        animation.repeatCount = Float(OPEN_MAX)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        scanLineImageView.layer.add(animation, forKey: "LineAnimation")
    }
    
    func _removeAnimation(){
        scanLineImageView.layer.removeAnimation(forKey: "LineAnimation")
        scanLineImageView.isHidden = true
    }
}

// MARK: - FlashLight

fileprivate extension TTAQRCodeScanViewController {
    
    @objc func _exchangeFlashlight() {
        if let device = device {
            do {
                captureSession.beginConfiguration()
                try device.lockForConfiguration()
                isTouchOn ? _turnOffFlashLight() : _turnOnFlashlight()
                device.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    func _turnOnFlashlight() {
        if let device = device, device.isFlashModeSupported(.on) == true {
            device.torchMode = .on
            isTouchOn = true
            tipLabel.text = TTAQRCodeScanViewControllerConst.turnOffFlashLightTip
            flashlightButton.isSelected = true
        }
    }
    
    func _turnOffFlashLight() {
        if let device = device, device.isFlashModeSupported(.off) == true {
            device.torchMode = .off
            isTouchOn = false
            tipLabel.text = TTAQRCodeScanViewControllerConst.turnOnFlashLightTip
            flashlightButton.isSelected = false
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension TTAQRCodeScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage,
            let result = image.tta.scanQRCode()?.last else {
                imagePicker.dismiss(animated: true, completion: nil)
                self.hasCode = false
                return
        }
        hasCode = true
        if qrCodeScanResultHandler == nil {
            fatalError("You must set `qrCodeScanResultHandler` to handle the scan result")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        self.qrCodeScanResultHandler!(result)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate & AVCaptureVideoDataOutputSampleBufferDelegate

extension TTAQRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let codeObj = metadataObjects.last as? AVMetadataMachineReadableCodeObject,
            let result = codeObj.stringValue else {
                hasCode = false
                return
        }
        hasCode = true
        if qrCodeScanResultHandler == nil {
            fatalError("You must set `qrCodeScanResultHandler` to handle the scan result")
        }
        captureSession.stopRunning()
        _removeAnimation()
        qrCodeScanResultHandler!(result)
    }
    
    /// 检测当前光线状态
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let metadataDic = CMCopyDictionaryOfAttachments(nil, sampleBuffer, kCMAttachmentMode_ShouldPropagate) else { return }
        let metadata = NSDictionary(dictionary: metadataDic)
        let exifMetadata = metadata["{Exif}"] as! NSDictionary
        let brightnessValue: CGFloat = exifMetadata["BrightnessValue"] as! CGFloat
        guard !isTouchOn else { return }
        if brightnessValue <= -2 {
            flashlightButton.isHidden = false
            tipLabel.text = TTAQRCodeScanViewControllerConst.turnOnFlashLightTip
        } else {
            flashlightButton.isHidden = true
            tipLabel.text = hasCode ? TTAQRCodeScanViewControllerConst.scanTip : TTAQRCodeScanViewControllerConst.notFoundTip
        }
    }
}
