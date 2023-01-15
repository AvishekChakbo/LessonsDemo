//
//  LessonDemoUITests.swift
//  LessonDemoUITests
//
//  Created by Avishek Chakraborty on 13/01/23.
//

import XCTest

final class LessonDemoUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Lessons_() throws {
        let lessonScreenNav = app.navigationBars["Lessons"]
        XCTAssertTrue(lessonScreenNav.exists)
        
        let button =  app.collectionViews.buttons["The Key To Success In iPhone Photography"]
        XCTAssertTrue(button.exists)

        button.tap()
        
        let lessonDetailsScreenNav = app.navigationBars["_TtGC7SwiftUI19UIHosting"]
        XCTAssertTrue(lessonDetailsScreenNav.exists)
        
        let downloadButton = lessonDetailsScreenNav.buttons["Download"]
        XCTAssertTrue(downloadButton.exists)
        
        downloadButton.tap()
        
        let cancelButton = lessonDetailsScreenNav.buttons["In progress"]
        XCTAssertTrue(cancelButton.exists)
        
        let backButton = lessonDetailsScreenNav.buttons["Lessons"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let currentNav = app.navigationBars["Lessons"]
        XCTAssertTrue(currentNav.exists)
        
        XCUIApplication().collectionViews.cells.buttons["3 Secret iPhone Camera Features For Perfect Focus"].swipeUp()
        
    }
}
