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
        
        details_screen_should_make_sure_all_required_controls_are_present()
        
        details_screen_download_button_title_change_on_tap()
        
        should_go_back_to_lesson_list_screen_on_back_click()
                
    }
    
    func details_screen_should_make_sure_all_required_controls_are_present(){
        let detailsScrollView = app.scrollViews["LessonDetailsScrollView"]
        let _ = detailsScrollView.waitForExistence(timeout: 2.0)
        XCTAssertTrue(detailsScrollView.exists)
        
        let nextButton = app.buttons["LessonDetailsNextLesson"]
        XCTAssertTrue(nextButton.exists)
        
        let downloadButton = app.buttons["LessonDetailsDownload"]
        XCTAssertTrue(downloadButton.exists)
        
        let backButton = app.buttons["Lessons"]
        XCTAssertTrue(backButton.exists)
    }
    
    func details_screen_download_button_title_change_on_tap(){
        let downloadButton = app.buttons["LessonDetailsDownload"]
        XCTAssertEqual(downloadButton.label, "Download")
        downloadButton.tap()
        XCTAssertEqual(downloadButton.label, "In progress, Cancel")
    }
    
    func should_go_back_to_lesson_list_screen_on_back_click(){
        let backButton = app.buttons["Lessons"]
        backButton.tap()
        let currentScreen = app.navigationBars["Lessons"]
        let _ = currentScreen.waitForExistence(timeout: 0.5)
        XCTAssertTrue(currentScreen.exists)
    }
    
}
