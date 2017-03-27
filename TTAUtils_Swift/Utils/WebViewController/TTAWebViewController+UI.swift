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
        // webView
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: WKWebView.estimatedProgress)), options: [.new], context: &TTAWebViewControllerConst.observerContest)
        
        // progressView
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: progressView.bounds.size.height)
        progressView.trackTintColor = .white
        progressView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        progressView.tintColor = .green
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        
        // backItem
        backItem = UIButton(type: .custom)
        backItem.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        backItem.imageEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
        backItem.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        backItem.setImage(UIImage(named: "back_white"), for: .normal)
        backItem.addTarget(self, action: #selector(backItemAction(item:)), for: .touchUpInside)
        backView.addSubview(backItem)
        
        // closeItem
        
        closeItem = UIButton(type: .custom)
        closeItem.frame = CGRect(x: 26, y: 0, width: 30, height: 44)
        closeItem.setImage(UIImage(named: "close_white"), for: .normal)
        closeItem.addTarget(self, action: #selector(closeItemAction(item:)), for: .touchUpInside)
        closeItem.isHidden = true
        backView.addSubview(closeItem)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
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

// MARK: - Actions

extension TTAWebViewController {
    
    @objc fileprivate func backItemAction(item: UIButton) {
        if webView.canGoBack {
            webView.goBack()
            closeItem.isHidden = false
        } else {
            closeItemAction(item: closeItem)
        }
    }
    
    @objc fileprivate func closeItemAction(item: UIButton) {
        if presentingViewController == nil {
            let _ = navigationController?.popViewController(animated: true)
        } else {
            let _ = dismiss(animated: true, completion: nil)
        }
    }
}
