//
//  ModelTests.swift
//  NetguruGifyTests
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import NetguruGify

class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPaginationMetadataPages() {
        
        let metadata = PaginationMetadata(totalCount: 112122, count: 25, offset: 0)
        
        XCTAssertEqual(metadata.pages, 4485, "Invalid calculation of pages count.")
    }
    
    func testEquatableOfGify() {
        
        let gify1 = Gify(id: "1", title: "Test 1", images: JSON(), type: "gif")
        let gify2 = Gify(id: "1", title: "Test 1", images: JSON(), type: "gif")
        let gify3 = Gify(id: "2", title: "Test 2", images: JSON(), type: "git")
        
        XCTAssertEqual(gify1, gify2, "Gify 1 & 2 should be equal")
        XCTAssertNotEqual(gify2, gify3, "Gify 2 & 3 should not be equal")
        XCTAssertNotEqual(gify1, gify3, "Gify 1 & 3 should not be equal")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
