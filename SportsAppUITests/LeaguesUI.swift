//
//  LeaguesUI.swift
//  SportsAppUITests
//
//  Created by Amin on 29/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import XCTest

class LeaguesUI: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws{
        
        let app = XCUIApplication()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Soccer").element.tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .searchField).element.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["English League 1"]/*[[".cells.staticTexts[\"English League 1\"]",".staticTexts[\"English League 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
               
    }
    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
