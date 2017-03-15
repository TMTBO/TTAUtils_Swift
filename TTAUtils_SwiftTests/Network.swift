//
//  Network.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 14/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import XCTest
import Alamofire

//struct MainService: ServiceProtocol {
//    
//    var params: [String : String]?
//    var method: HTTPMethod
//    var api: String
//    var headers: HTTPHeaders {
//        return [
//            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//            "Accept": "application/json"
//        ]
//    }
//    var baseUrlString: String! {
//        return "https://www.tobyotenma.top"
//    }
//    
//    enum Apis: String {
//        case first = "ReadBlog/php"
//        case second = ""
//    }
//    
//    init(api: Apis, method: HTTPMethod, params: [String: String]?) {
//        self.api = api.rawValue
//        self.method = method
//        self.params = params
//    }
//}

enum Router: URLRequestConvertible {
    case createUser(parameters: Parameters)
    case readUser(username: String)
    case updateUser(username: String, parameters: Parameters)
    case destroyUser(username: String)
    
    static let baseURLString = "https://www.tobyotenma.top"
    
    var method: HTTPMethod {
        switch self {
        case .createUser:
            return .get
        case .readUser:
            return .post
        case .updateUser:
            return .put
        case .destroyUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "ReadBlog/php"
        case .readUser(let username):
            return "/users/\(username)"
        case .updateUser(let username, _):
            return "/users/\(username)"
        case .destroyUser(let username):
            return "/users/\(username)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        urlRequest.timeoutInterval = 30.0
        return urlRequest
    }
}

class Network: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiProxy() {
        
        let exp = expectation(description: "NOT fulfill")
        ApiManager.shared.request(with: Router.createUser(parameters: [:])) { (json) in
            print(json ?? "")
            exp.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}
