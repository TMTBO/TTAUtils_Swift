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
    
    fileprivate let captureSession = AVCaptureSession()
    
    var qrCodeScanResultHandler: ((String?) -> ())?
    
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
}

fileprivate extension TTAQRCodeScanViewController {
    
    func _scanQRCode() {
        do {
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            
            guard captureSession.canAddInput(input) else { return }
            captureSession.addInput(input)
            
            guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            guard captureSession.canAddOutput(output) else { return }
            captureSession.addOutput(output)
            
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code] // AVMetadataObjectTypeCode128Code
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureSession.startRunning()
            
        } catch {
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",
                                                    message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension TTAQRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let codeObj = metadataObjects.last as? AVMetadataMachineReadableCodeObject else { return }
        let result = codeObj.stringValue
        if qrCodeScanResultHandler == nil {
            fatalError("You must set `qrCodeScanResultHandler` to handle the scan result")
        }
        captureSession.stopRunning()
        qrCodeScanResultHandler!(result)
    }
}
