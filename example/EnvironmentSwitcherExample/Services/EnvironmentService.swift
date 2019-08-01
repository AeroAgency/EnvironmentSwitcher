//
//  EnvironmentService.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 14/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import EnvironmentSwitcher
import Foundation

// MARK: - extension and protocol for detection server url did changed
extension NSNotification.Name {
    static let serverChanged = Notification.Name(rawValue: "serverChanged")
}

@objc protocol EnvironmentListener {
    func startEnvironmentListen()
    func shouldChangeServerTo(_ newServer: String)
}

extension EnvironmentListener {
    func fetchDomainFromNotification(_ notification: Notification) -> String? {
        guard let newDomain = notification.userInfo?[Notification.Name.serverChanged] as? String else {
            print("ATTENTION!!! Dont can get new server")
            
            #if DEBUG
            fatalError("New server address dont detected")
            #else
            return nil
            #endif
        }
        return newDomain
    }
}

// MARK: - swither singleton
class EnvironmentService {

    // MARK: variables
    private static let shared = EnvironmentService()
    private(set) var switcher: EnvironmentSwitcher
    
    private let serversList = ["https://prod.com", "https://predprod.com", "http://st.mainDomain.com", "http://dev.mainDomain.com"]
    private(set) var currentServer: String
    
    // MARK: life cycle and init
    @discardableResult
    static func shared(_ app: MainWindowContaner? = nil) -> EnvironmentService {
        if let appInstance = app {
            _ = appInstance.mainWindow
            shared.configFor(appInstance)
        }
        return shared
    }
    
    private func configFor(_ app: MainWindowContaner?) {

        let config = ServersListConfigurator(servers: serversList, current: currentServer, shouldSelectOnStart: true)
        
        let application = app ?? (UIApplication.shared)
        switcher = EnvironmentSwitcher(config, app: application)
        switcher.delegate = self
    }
    
    private init() {
        currentServer = serversList[1]
        let config = ServersListConfigurator(servers: serversList, current: currentServer, shouldSelectOnStart: true)
        
        switcher = EnvironmentSwitcher(config)
        switcher.delegate = self
    }

}


// MARK: - environment  swither delegate
extension EnvironmentService: EnvironmentSwitcherDelegate {
    func serverDidChanged(_ newServer: String) {
        currentServer = newServer
        
        let userInfo = [NSNotification.Name.serverChanged: newServer]
        let notification = Notification(name: .serverChanged, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification) // or maybe delegate to REST service
        
    }
}
