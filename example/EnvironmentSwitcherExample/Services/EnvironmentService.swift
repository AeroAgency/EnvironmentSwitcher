//
//  EnvironmentService.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 14/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import Foundation
import EnvironmentSwitcher

extension NSNotification.Name {
    static let serverChanged = Notification.Name(rawValue: "serverChanged")
}

protocol EvironmentListener: class {
    func startEnvironmentListen()
    func shouldChangeServer(newServer: String)
}

class EnvironmentService: EnvironmentSwitcherDelegate {

    private static let shared = EnvironmentService()
    
    @discardableResult
    static func shared(_ app: MainWindowContaner? = nil) -> EnvironmentService {
        if let appInstance = app {
            let _ = appInstance.mainWindow
            shared.configFor(appInstance)
        }
        return shared
    }
    
    private func configFor(_ app: MainWindowContaner?) {

        let config = ServersListConfigurator(servers: serversList, current: currentServer, shouldSelectOnStart: true)
        let config2 = Serv
        
        let application = app ?? (UIApplication.shared)
        switcher = EnvironmentSwitcher(config, app: application)
        switcher.delegate = self
    }
    
    private(set) var switcher: EnvironmentSwitcher
    
    private let serversList = ["https://prod.com", "https://predprod.com", "http://st.mainDomain.com", "http://dev.mainDomain.com"]
    private(set) var currentServer: String
    
    private init() {
        currentServer = serversList[1]
        let config = ServersListConfigurator(servers: serversList, current: currentServer, shouldSelectOnStart: true)
        
        switcher = EnvironmentSwitcher(config)
        switcher.delegate = self
    }
    
    func serverDidChanged(_ newServer: String) {
        currentServer = newServer
        
        let userInfo = [NSNotification.Name.serverChanged: newServer]
        let notification = Notification(name: .serverChanged, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
}
