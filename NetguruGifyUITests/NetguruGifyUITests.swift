//
//  NetguruGifyUITests.swift
//  NetguruGifyUITests
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import XCTest

class NetguruGifyUITests: XCTestCase {
    
    var app : XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavouriteGifys() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .button).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .button).element.tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 3).children(matching: .button).element.tap()
        app.navigationBars["NetguruGify.GifyListView"].buttons["Star"].tap()
        
        XCTAssertEqual(app.collectionViews.children(matching: .cell).count, 3)
        
    }

}
