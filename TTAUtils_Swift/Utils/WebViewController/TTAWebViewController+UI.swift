//
//  TTAWebViewController+UI.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 22/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import WebKit

extension TTAWebViewController {
    
    func setupUI() {
        _addViews()
        _configWebView()
        _layoutViews()
    }
    
    private func _addViews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func _configWebView() {
        
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: WKWebView.estimatedProgress)), options: [.new], context: &TTAWebViewControllerConst.observerContest)
        
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: progressView.bounds.size.height)
        progressView.trackTintColor = .white
        progressView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        progressView.tintColor = .green
    }
    
    private func _layoutViews() {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let awebView = object as? WKWebView, awebView === webView && keyPath == NSStringFromSelector(#selector(getter: WKWebView.estimatedProgress)) {
            progressView.alpha = 1
            let animated = Float(webView.estimatedProgress) > progressView.progress
            progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
            
            // Once complete, fade out UIProgressView
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finished) in
                    self.progressView.setProgress(0, animated: false)
                })
            }
        }
    }
}
