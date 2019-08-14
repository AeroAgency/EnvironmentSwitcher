//
//  EnvironmentSwitcherTests.swift
//  EnvironmentSwitcherTests
//
//  Created by Stas on 02/08/2019.
//

@testable import EnvironmentSwitcher
import XCTest

class MockUIApplication: MainWindowContaner {
    var mainWindow: UIWindow? {
        return UIWindow()
    }
}

private enum GoodData {
    static let domainsList = ["http://test.domain.com/", "https://subtest.test.domain.com/", "https://domain.com/"]
    static let defaultDomain = "https://subtest.test.domain.com/"
}

private enum BadData {
    static let domainsList = ["test.domain.com/", "https://", "fdagadfgda"]
    static let defaultDomain = "https://someDomain.com/"
}

class EnvironmentSwitcherTests: XCTestCase {
    
    var windowService: SwitcherWindowService!
    
    var configuratorGood: ServersListConfigurator!
    var configuratorBad: ServersListConfigurator!
    var configuratorWithoutDefaultServer: ServersListConfigurator!
    
    var serviceGood: SwitcherService!
    var serviceBad: SwitcherService!
    var serviceWithoutDefaultServer: SwitcherService!
    
    override func setUp() {
        super.setUp()
        let appTest = MockUIApplication()
        
        windowService = SwitcherWindowService.shared(appTest)
        
        configuratorGood = ServersListConfigurator(servers: GoodData.domainsList, current: GoodData.defaultDomain, shouldSelectOnStart: false)
        serviceGood = SwitcherService(config: configuratorGood, service: windowService)
        
        configuratorBad = ServersListConfigurator(servers: BadData.domainsList, current: BadData.defaultDomain, shouldSelectOnStart: false)
        serviceBad = SwitcherService(config: configuratorBad, service: windowService)
        
        configuratorWithoutDefaultServer = ServersListConfigurator(servers: GoodData.domainsList, shouldSelectOnStart: false)
        serviceWithoutDefaultServer = SwitcherService(config: configuratorWithoutDefaultServer, service: windowService)
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
    
    func testDefaultServer() {
        XCTAssertTrue(serviceWithoutDefaultServer.current == GoodData.domainsList.first)
    }
    
    func testSettingsServerSaving() {
        XCTAssertTrue(configuratorWithoutDefaultServer.settings.isServerShouldSave)
        XCTAssertTrue(configuratorWithoutDefaultServer.settings.savedServer == serviceWithoutDefaultServer.current)
    }
    
    func testSettingsNotSaveServer() {
        configuratorWithoutDefaultServer.settings.isServerShouldSave = false
        XCTAssertNil(configuratorWithoutDefaultServer.settings.savedServer)
        configuratorWithoutDefaultServer.settings.isServerShouldSave = true
    }
    
    func testSavingServer() {
        let settings = Settings()
        
        configuratorWithoutDefaultServer.settings.isServerShouldSave = true
        configuratorWithoutDefaultServer.settings.savedServer = GoodData.defaultDomain
        
        XCTAssertTrue(settings.savedServer == GoodData.defaultDomain)
        
        configuratorWithoutDefaultServer.settings.savedServer = GoodData.domainsList.first
        XCTAssertTrue(settings.savedServer == GoodData.domainsList.first)
    }
}
