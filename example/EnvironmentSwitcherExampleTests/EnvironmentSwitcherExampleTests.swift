//
//  EnvironmentSwitcherExampleTests.swift
//  EnvironmentSwitcherExampleTests
//
//  Created by Stas on 13/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

@testable import EnvironmentSwitcher
@testable import EnvironmentSwitcherExample
import XCTest

private let kDomainsList = ["http://test.domain.com/", "https://subtest.test.domain.com/", "https://domain.com/"]
private let kDefaultDomain = "https://subtest.test.domain.com/"

class EnvironmentSwitcherExampleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSelectServerBeforeOpenApp() {
        let configurator = ServersListConfigurator(servers: kDomainsList, current: kDefaultDomain, shouldSelectOnStart: true)
        _ = EnvironmentSwitcher(configurator)
        
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        XCTAssertNotNil(rootVc, "root controller is nil")
        
        let rootVcClassName = String(describing: type(of: rootVc))
        XCTAssertNotNil(rootVcClassName, "root controller is nil")
//        XCTAssertTrue(rootVcClassName == "AppStartRootController", "Invalid application key window root controlerr class")
    }
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
