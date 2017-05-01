//
//  TopicsListUITests.swift
//  TopicsListUITests
//
//  Created by Iggy Mwangi on 4/30/17.
//  Copyright © 2017 Iggy Mwangi. All rights reserved.
//

import XCTest

class TopicsListUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let addButton = app.navigationBars["The List"].buttons["Add"]
        addButton.tap()
        
        let aKey = app.keys["a"]
        aKey.tap()
        
        let textField = app.alerts["New Topic"].collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.typeText("a")
        app.keys["space"].tap()
        textField.typeText(" ")
        
        let tKey = app.keys["t"]
        tKey.tap()
        textField.typeText("t")
        
        let oKey = app.keys["o"]
        oKey.tap()
        textField.typeText("o")
        app.typeText("p")
        
        let table = app.otherElements.containing(.navigationBar, identifier:"The List").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        table.tap()
        app.typeText("i")
        table.tap()
        app.typeText("c")
        table.tap()
        addButton.tap()
        aKey.tap()
        textField.typeText("a")
        app.keys["n"].tap()
        textField.typeText("n")
        oKey.tap()
        textField.typeText("o")
        tKey.tap()
        textField.typeText("t")
        app.keys["h"].tap()
        textField.typeText("h")
        app.keys["e"].tap()
        textField.typeText("e")
        app.keys["r"].tap()
        textField.typeText("r")
        app.typeText(" ")
        table.tap()
        app.typeText("t")
        table.tap()
        app.typeText("o")
        table.tap()
        app.typeText("pi")
        table.tap()
        app.typeText("c")
        table.tap()
        
    }
    
}
