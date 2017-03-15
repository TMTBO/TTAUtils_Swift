//
//  ApiManager.swift
//  SwiftNetworkDemo
//
//  Created by TobyoTenma on 14/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager {
    
    static let shared = ApiManager()
    
    fileprivate var sessionManager = Alamofire.SessionManager.default
    
    private init() {
        self.set("token", time: "time")
    }
    
    private var dispatchTable = [Int: DataRequest]()
    
    open func set(_ token: String?, time: String?) {
        var defaultHeaders = SessionManager.defaultHTTPHeaders
        defaultHeaders["token"] = token
        defaultHeaders["time"] = time
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        self.sessionManager = sessionManager
    }
    
    open func request(with request: URLRequestConvertible, completionHandler: @escaping (ApiResponse?) -> Void) {
        if let _ = dispatchTable[request.urlRequest?.hashValue ?? 0] { return }
        let dataRequest = sessionManager.request(request).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
                self.logSuccess(request: request)
                let apiResponse = ApiResponse(request: request, response: response.result.value as? [String: Any?])
                completionHandler(apiResponse)
            case .failure(let error):
                self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
                self.logFailure(request: request, error: error)
                let apiErrorResponse = ApiResponse(request: request, error: error as NSError)
                completionHandler(apiErrorResponse)
            }
        })
        dispatchTable[dataRequest.request?.hashValue ?? 0] = dataRequest
    }
}

extension ApiManager {
    
    fileprivate func logSuccess(request: URLRequestConvertible) {
        #if DEBUG
            print("\n===================== Response Success =====================")
            print("\n \(request.urlRequest?.url?.absoluteString) ")
            print("\n \(sessionManager.session.configuration.httpAdditionalHeaders) ")
            print("\n===================== Response Success =====================\n")
        #endif
    }
    
    fileprivate func logFailure(request: URLRequestConvertible, error: Error) {
        #if DEBUG
            print("\n===================== Response Failure =====================")
            print("\n \(request.urlRequest?.url?.absoluteString) ")
            print("\n \(sessionManager.session.configuration.httpAdditionalHeaders) ")
            print("\n===================== Error =====================")
            print("\n \(error) ");
            print("\n===================== Response Failure =====================\n")
        #endif
    }
    
}
