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
    
    func test_should_make_sure_screen_is_displayed() {
        let navBarTitle = app.staticTexts["Lessons"]
        XCTAssert(navBarTitle.waitForExistence(timeout: 0.5))
    }
    
    func test_should_make_sure_all_required_controls_are_present() {
        XCTAssertTrue(app.otherElements["LesssonNavigationView"].exists)
        XCTAssertTrue(app.collectionViews["LesssonList"].exists)
        XCTAssertTrue(app.buttons["LesssonCell"].exists)
    }
    
    func test_should_navigate_to_details_screen() throws {
        let list = app.collectionViews["LesssonList"]
        let cell = list.descendants(matching: .button).firstMatch
        cell.tap()
        
        let detailsScrollView = app.scrollViews["LessonDetailsScrollView"]
        let _ = detailsScrollView.waitForExistence(timeout: 0.5)
        XCTAssertTrue(detailsScrollView.exists)
        
        
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
                
    }
}
