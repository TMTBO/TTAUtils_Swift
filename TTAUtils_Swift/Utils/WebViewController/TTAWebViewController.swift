//
//  TTAWebViewController.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 22/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import WebKit

class TTAWebViewController: UIViewController {
    
    struct TTAWebViewControllerConst {
        static var observerContest = "observerContest"
    }
    
    fileprivate(set) var webView: WKWebView
    
    let progressView = UIProgressView(progressViewStyle: .default)
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        webView = WKWebView()
    }
    
    convenience init(jsCalled messages: [String]) {
        self.init(nibName: nil, bundle: nil)
        
        let messageHandler = WeakScriptMessageHandler(delegate: self)
        
        let userController = WKUserContentController()
        _ = messages.map { userController.add(messageHandler, name: $0) }
        let config = WKWebViewConfiguration()
        config.userContentController = userController
        webView = WKWebView(frame: .zero, configuration: config)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: WKWebView.estimatedProgress)))
        Log(message: "\(NSStringFromClass(type(of: self))) deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Life Cycle

extension TTAWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewController()
        setupUI()
        let path = Bundle.main.path(forResource: "Test.html", ofType: nil)
        webView.load(URLRequest(url: URL(fileURLWithPath: path!)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}
