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
    
    // MARK: - Public Properties
    /// The url web view will load with the default `cachePolicy` and `timeoutInterval`
    open private(set) var url: URL?
    /// The request web view will load
    /// User can define the `cachePolicy` and `timeoutInterval`
    open private(set) var request: URLRequest?
    /// The messages the javaScript will call
    open private(set) var messages: [String]?
    /// Wether the user can swipe to pop `TTAWebViewController`
    /// Default is `true`
    open var canSwipeBack: Bool = true
    
    // MARK: - Private Properties
    fileprivate(set) var webView: WKWebView
    var backItem = UIButton()
    var closeItem = UIButton()
    fileprivate var delegate: UIGestureRecognizerDelegate?
    
    let progressView = UIProgressView(progressViewStyle: .default)
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        webView = WKWebView()
    }
    
    convenience init(url: URL?, jsCalled messages: [String]? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.messages = messages
        webView = WKWebView(frame: .zero, configuration: _createWebViewConfig(messages: messages))
        if let aurl = url {
            let request = URLRequest(url: aurl)
            webView.load(request)
        }
    }
    
    convenience init(request: URLRequest?, jsCalled messages: [String]? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.messages = messages
        webView = WKWebView(frame: .zero, configuration: _createWebViewConfig(messages: messages))
        if let aRequest = request {
            webView.load(aRequest)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        webView = WKWebView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        webView = WKWebView()
        super.init(coder: aDecoder)
    }
    
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: WKWebView.estimatedProgress)))
        Log("\(NSStringFromClass(type(of: self))) deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func _createWebViewConfig(messages: [String]?) -> WKWebViewConfiguration {
        let messageHandler = WeakScriptMessageHandler(delegate: self)
        let userController = WKUserContentController()
        _ = messages?.map { userController.add(messageHandler, name: $0) }
        let config = WKWebViewConfiguration()
        config.userContentController = userController
        return config
    }
}

// MARK: - Life Cycle

extension TTAWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViewController()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard canSwipeBack else { return }
        if let aCount = navigationController?.viewControllers.count, aCount > 1 {
            delegate = navigationController?.interactivePopGestureRecognizer?.delegate
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard canSwipeBack else { return }
        navigationController?.interactivePopGestureRecognizer?.delegate = delegate
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TTAWebViewController {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let aCount = navigationController?.childViewControllers.count, aCount > 0 else { return false }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let aCount = navigationController?.childViewControllers.count, aCount > 0 else { return false }
        return true
    }
}

extension TTAWebViewController {
    
    struct TTAWebViewControllerConst {
        static var observerContest = "observerContest"
    }
}
