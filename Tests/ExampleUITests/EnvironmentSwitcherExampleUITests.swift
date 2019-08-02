//
//  EnvironmentSwitcherExampleUITests.swift
//  EnvironmentSwitcherExampleUITests
//
//  Created by Stas on 02/08/2019.
//

@testable import EnvironmentSwitcher
@testable import EnvironmentSwitcherExample
import XCTest

extension XCUIApplication: MainWindowContaner {
    public var mainWindow: UIWindow? {
        let window = UIWindow()
        window.makeKeyAndVisible()
        return window
    }
}

class EnvironmentSwitcherExampleUITests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        XCTAssertNotNil(EnvironmentService.shared(XCUIApplication()).currentServer)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppLaunchOpened() {
        
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts[EnvironmentService.shared().currentServer].exists)
        XCTAssertFalse(app.staticTexts[EnvironmentService.shared().currentServer].isHittable)
        
        XCTAssertTrue(app.pickers.count == 1)
        XCTAssertTrue(app.pickers.firstMatch.isHittable)
        
        XCTAssertTrue(app.toolbars["Toolbar"].buttons["Done"].exists)
        XCTAssertTrue(app.toolbars["Toolbar"].buttons["Cancel"].exists)
    }
    
    
    func testHideAfterChangeServerOnRun() {
        
        let app = XCUIApplication()
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.pickers.pickerWheels["https://predprod.com"]/*[[".pickers.pickerWheels[\"https:\/\/predprod.com\"]",".pickerWheels[\"https:\/\/predprod.com\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        XCTAssertTrue(app.pickers.count == 0)
    }
    
    func testCancelDialog() {
        let app = XCUIApplication()
        
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        XCTAssertTrue(app.pickers.count == 0)
        XCTAssertTrue(app.staticTexts[EnvironmentService.shared().currentServer].exists)
    }
    
    func testIconDefaultState() {
        
        let app = XCUIApplication()
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 1)
        let image = app.images["domain"]
        
        XCTAssertTrue(element.isHittable)
        XCTAssertFalse(image.exists)
    }
    
    
    func testIconDoubledTap() {
        let app = XCUIApplication()
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 1)
        let image = app.images["domain"]
        
        element.doubleTap()
        
        XCTAssertFalse(element.isHittable)
        XCTAssertTrue(image.exists)
        XCTAssertTrue(image.isHittable)
    }
    
    func testIconQuadrupleTap() {
        let app = XCUIApplication()
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 1)
        let image = app.images["domain"]
        
        element.doubleTap()
        image.doubleTap()
        
        XCTAssertFalse(image.exists)
        XCTAssertTrue(element.isHittable)
    }
    
    
    func testOpenDialog() {
        let app = XCUIApplication()
        app.toolbars["Toolbar"].buttons["Cancel"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 1)
        let image = app.images["domain"]
        
        element.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        image.press(forDuration: 3)
        
        XCTAssertFalse(image.exists)
        XCTAssertTrue(app.pickers.count == 1)
    }
}
