//
//  TTAWebViewController+WKScriptMessageHandler.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 22/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import WebKit

// MARK: - WKScriptMessageHandler

extension TTAWebViewController: WKScriptMessageHandler {
    
    private enum ScriptMessages: String {
        case test
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let amessage = ScriptMessages(rawValue: message.name) else { return }
        switch amessage {
        case .test:
            Log(message: message.body)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                let prama = "Hello"
                self.webView.evaluateJavaScript("ios_call_js('\(prama)', 'World')", completionHandler: { (item, error) in
                    Log(message: item, error)
                })
            })
        }
    }
}
