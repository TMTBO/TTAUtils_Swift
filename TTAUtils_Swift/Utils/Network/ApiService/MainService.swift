//
//  MainService.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 15/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit
import  Alamofire

enum MainService {
    
    case createUser(parameters: Parameters)
    case readUsera(username: String)
    case readUser(username: String)
    case updateUser(username: String, parameters: Parameters)
    case destroyUser(username: String)
}

// MARK: - Static config

extension MainService {
    static let baseURLString = "http://127.0.0.1"
}

// MARK: - Method

extension MainService {
    
    var method: HTTPMethod {
        switch self {
        case .createUser,
             .readUsera : return .get
        case .readUser: return .post
        case .updateUser:  return .put
        case .destroyUser: return .delete
            
            
            
        }
    }
}

// MARK: - Path

extension MainService {
    
    var path: String {
        switch self {
        case .createUser,
             .readUsera :
            return "/dev_php/ReadBolg/index.php"
        case .readUser(let username):
            return "/users/\(username)"
        case .updateUser(let username, _):
            return "/users/\(username)"
        case .destroyUser(let username):
            return "/users/\(username)"
        }
    }
}

// MARK: URLRequestConvertible

extension MainService: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = try MainService.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 30.0
        
        switch self {
        case .createUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        return urlRequest
    }
}
