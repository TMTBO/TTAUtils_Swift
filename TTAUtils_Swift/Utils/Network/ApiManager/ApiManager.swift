//
//  ApiManager.swift
//  SwiftNetworkDemo
//
//  Created by TobyoTenma on 14/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import Alamofire

typealias TTAURLRequestConvertible = URLRequestConvertible

class ApiManager {
    
    static let shared = ApiManager()
    
    fileprivate var sessionManager = Alamofire.SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    
    static let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "127.0.0.1": .pinCertificates(
            certificates: ServerTrustPolicy.certificates(),
            validateCertificateChain: true,
            validateHost: true
        ),
        "": .disableEvaluation
    ]

    
    private init() {
        self.set("token", time: "time")
    }
    
    private var dispatchTable = [Int: DataRequest]()
    
    /// Set Token and Time for the request header
    open func set(_ token: String?, time: String?) {
        var defaultHeaders = SessionManager.defaultHTTPHeaders
        defaultHeaders["token"] = token
        defaultHeaders["time"] = time
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        self.sessionManager = sessionManager
    }
    
    /// Api Request
    open func request(with request: TTAURLRequestConvertible, completionHandler: @escaping (ApiResponse?) -> Void) {
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
    
    /// Upload Images
    open func upload(with request: TTAURLRequestConvertible, images: [UIImage], completionHandler: @escaping (ApiResponse?) -> Void) {
        if let _ = dispatchTable[request.urlRequest?.hashValue ?? 0] { return }
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            _ = images.enumerated().map({ (item) in
                guard let data = UIImagePNGRepresentation(item.element) else { return }
                multipartFormData.append(data, withName: "img_\(item.offset)")
            })
        }, with: request) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }).responseJSON { response in
                    self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
                    self.logSuccess(request: request)
                    let apiResponse = ApiResponse(request: request, response: response.result.value as? [String: Any?])
                    completionHandler(apiResponse)
                }
                self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
            case .failure(let encodingError):
                self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
                self.logFailure(request: request, error: encodingError)
                let apiErrorResponse = ApiResponse(request: request, error: encodingError as NSError)
                completionHandler(apiErrorResponse)
                self.dispatchTable.removeValue(forKey: request.urlRequest?.hashValue ?? 0)
            }
        }
        dispatchTable[request.urlRequest?.hashValue ?? 0] = request as? DataRequest
    }
}

extension ApiManager {
    
    fileprivate func logSuccess(request: TTAURLRequestConvertible) {
        #if DEBUG
            print("\n===================== Response Success =====================")
            print("\n \(String(describing: request.urlRequest?.url?.absoluteString)) ")
            print("\n \(String(describing: sessionManager.session.configuration.httpAdditionalHeaders)) ")
            print("\n===================== Response Success =====================\n")
        #endif
    }
    
    fileprivate func logFailure(request: TTAURLRequestConvertible, error: Error) {
        #if DEBUG
            print("\n===================== Response Failure =====================")
            print("\n \(String(describing: request.urlRequest?.url?.absoluteString)) ")
            print("\n \(String(describing: sessionManager.session.configuration.httpAdditionalHeaders)) ")
            print("\n===================== Error =====================")
            print("\n \(error) ");
            print("\n===================== Response Failure =====================\n")
        #endif
    }
    
}
