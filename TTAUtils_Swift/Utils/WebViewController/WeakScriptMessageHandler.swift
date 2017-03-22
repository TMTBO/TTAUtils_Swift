//
//  WeakScriptMessageHandler.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 22/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import WebKit

class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler?) {
        self.delegate = delegate
        super.init()
    }
    
    /*! @abstract Invoked when a script message is received from a webpage.
     @param userContentController The user content controller invoking the
     delegate method.
     @param message The script message received.
     */
    @available(iOS 8.0, *)
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }

    
}
