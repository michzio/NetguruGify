//
//  NetguruGifyTests.swift
//  NetguruGifyTests
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import XCTest
@testable import NetguruGify

class NetguruGifyTests: XCTestCase {
    
    var gifyService: GifyService!

    override func setUp() {
        super.setUp()
        
        gifyService = GifyService()
    }

    override func tearDown() {
        gifyService = nil
        
        super.tearDown()
    }

    func testGetRequest() {
        
        let url = URL(string: "https://google.com")
        
        let promise = expectation(description: "completion invoked")
        var data : Data?
        var error : Error?
        
        gifyService.get(url: url!) { (d, e) in
            data = d
            error = e
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertNotNil(data)
    }
    
    func testGetDecodableRequest() {
        
        var urlComponents = URLComponents(string: Settings.apiUrl)
        urlComponents?.query = "api_key=\(Settings.apiKey)&offset=1"
       
        let url = urlComponents?.url
        
        let promise = expectation(description: "completion invoked")
        var data : GifyData?
        var error : Error?
        
       
        gifyService.get(url: url!) { (d : GifyData?, e : Error?) in
            
            data = d
            error = e
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertNotNil(data)
        
        XCTAssertEqual(data!.pagination.offset, 1)
        
    }
    
    func testGetGifyDataRequest() {
        
        let promise = expectation(description: "completion invoked")
        var data : GifyData?
        var error : Error?
        
        gifyService.getGifyData(offset: 1) { (d, e) in
            data = d
            error = e
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(error)
        XCTAssertNotNil(data)
        
        XCTAssertEqual(data!.pagination.offset, 1)
    }

}
