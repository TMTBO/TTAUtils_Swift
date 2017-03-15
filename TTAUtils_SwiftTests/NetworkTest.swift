//
//  NetworkTest.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 14/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import XCTest
@testable import TTAUtils_Swift

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
        ApiManager.shared.request(with: MainService.createUser(parameters: ["hello":"aaaa"])) { (json) in
            print(json?.data ?? "nothing here")
            exp.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}
