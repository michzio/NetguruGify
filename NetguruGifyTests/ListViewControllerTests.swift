//
//  ListViewControllerTests.swift
//  NetguruGifyTests
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import XCTest
@testable import NetguruGify

class ListViewControllerTests: XCTestCase {
    
    var vc: GifyListViewController!

    override func setUp() {
        super.setUp()
        
        vc = GifyListViewController()
        
        let bundle = Bundle(for: type(of: self))
        let filePath = bundle.path(forResource: "sample", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: filePath!), options: .alwaysMapped)
        
        let mock = GifyServiceMock(data: data, error: nil)
        
        vc.gifyService = mock
        
    }

    override func tearDown() {
        vc = nil
       super.tearDown()
    }

    func testLoadGifyData() {
      
        let promise = expectation(description: "Loaded gify data")
        
        XCTAssertEqual(vc.elements.count, 0, "Initially there should not be any elements")
        
        vc.loadContent(refreshing: true) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(vc.elements.count, 25, "After loading content should be 25 elements")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
