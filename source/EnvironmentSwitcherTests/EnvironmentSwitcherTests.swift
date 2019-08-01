//
//  EnvironmentSwitcherTests.swift
//  EnvironmentSwitcherTests
//
//  Created by Stas on 24/05/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

@testable import EnvironmentSwitcher
import XCTest

class MockUIApplication: MainWindowContaner {
    var mainWindow: UIWindow? {
        return UIWindow()
    }
}

private enum GoodData {
    static let kDomainsList = ["http://test.domain.com/", "https://subtest.test.domain.com/", "https://domain.com/"]
    static let kDefaultDomain = "https://subtest.test.domain.com/"
}

private enum BadData {
    static let kDomainsList = ["test.domain.com/", "https://", "fdagadfgda"]
    static let kDefaultDomain = "https://someDomain.com/"
}

class EnvironmentSwitcherTests: XCTestCase {
    
    var windowService: SwitcherWindowService!
    
    var configuratorGood: ServersListConfigurator!
    var configuratorBad: ServersListConfigurator!
    
    var serviceGood: SwitcherService!
    var serviceBad: SwitcherService!

    override func setUp() {
        super.setUp()
        let appTest = MockUIApplication()
        
        windowService = SwitcherWindowService.shared(appTest)
        
        configuratorGood = ServersListConfigurator(servers: GoodData.kDomainsList, current: GoodData.kDefaultDomain, shouldSelectOnStart: false)
        serviceGood = SwitcherService(config: configuratorGood, service: windowService)
        
        configuratorBad = ServersListConfigurator(servers: BadData.kDomainsList, current: BadData.kDefaultDomain, shouldSelectOnStart: false)
        serviceBad = SwitcherService(config: configuratorBad, service: windowService)
    }
    
    override func tearDown() {
        super.tearDown()
        windowService = nil
        
        configuratorGood = nil
        configuratorBad = nil
        
        serviceGood = nil
        serviceBad = nil
    }

    func testCurrentIsCorrect() {
        let current = configuratorGood.currentServer
        XCTAssertNotNil(configuratorGood.serversList.firstIndex(of: current), "Current server not found in servers lists")
    }

    func testConfigIsUrl() {
        configuratorGood.serversList.forEach({
            let url = URL(string: $0)
            XCTAssertNotNil(url, "Server \($0) is not valid URL")
            XCTAssertNotNil(url?.scheme, "Server \($0) is not valid URL - bad scheme")
            XCTAssertNotNil(url?.host, "Server \($0) is not valid URL - bad host")
        })
    }
    
    func testCurrentIsInCorrect() {
        let current = configuratorBad.currentServer
        XCTAssertNil(configuratorBad.serversList.firstIndex(of: current), "Current server not found in servers lists")
    }
    
    func testConfigIsNotUrl() {
        configuratorBad.serversList.forEach({
            let url = URL(string: $0)
            XCTAssert(url == nil || url?.scheme == nil || url?.host == nil, "Server \($0) is valid URL!")
        })
    }
}
