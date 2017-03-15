//
//  ApiResponse.swift
//  Pods
//
//  Created by TobyoTenma on 14/03/2017.
//
//

import UIKit
import  Alamofire

public enum ApiResponseCode: Int {
    case success = 0
    case failure = 500
    
    case other = 10000
}

public class ApiResponse: NSObject {
    
    var request: URLRequestConvertible!
    var code: ApiResponseCode = .success
    var msg: String?
    var data: Any?
    var error: NSError?
    
    struct Default {
        static var decaultCode = ApiResponseCode.success
        static var defaultMsg = "This is a defaultMsg"
        static var defaultData: Any? = nil
    }
    
    public init(request: URLRequestConvertible, response: [String: Any?]?) {
        super.init()
        self.request = request
        self.code = response?["code"] as? ApiResponseCode ?? Default.decaultCode
        self.msg = response?["msg"] as? String ?? Default.defaultMsg
        self.data = response?["data"] ?? Default.defaultData
        self.error = handleResponse(response: response)
    }
    
    public init(request: URLRequestConvertible, error: NSError) {
        self.request = request
        self.code = ApiResponseCode(rawValue: error.code) ?? .failure
        self.msg = "Unknow error, please check the api and parameters /n \(error)"
        self.data = nil
    }
}

extension ApiResponse {
    
    fileprivate func handleResponse(response: [String: Any?]?) -> NSError? {
        
        var error: NSError? = nil
        
        switch code {
        case .success:
            return error
        case .failure:
            error = NSError(domain: self.request.urlRequest?.url?.host ?? "Unknow domain", code: code.rawValue, userInfo: response)
            return error
        default:
            return error
        }
        
    }
    
}
