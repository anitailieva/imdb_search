//
//  IMDBsearchUITests.swift
//  IMDBsearchUITests
//
//  Created by Anita Ilieva on 26/11/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import XCTest

class IMDBsearchUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
      
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        app.navigationBars["Movie View"].cells.accessibilityPerformMagicTap()
        XCTAssert(app.navigationBars["Movies"].exists)
        
        
        XCTAssert(app.tabBars.buttons["Search"].exists)
        XCTAssert(app.tabBars.buttons["Favorites"].exists)
        
    }
    
}
