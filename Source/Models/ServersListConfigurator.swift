//
//  ServersListConfigurator.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 24/05/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

/// Configuration of Envitontment switcher
public struct ServersListConfigurator {
    
    /// Return current server: saved server or first in list server
    public dynamic var server: String {
        return currentServer
    }
    
    private(set) var serversList: [String]
    private(set) var currentServer: String
    private(set) var shouldSelectBeforeFirstScreen: Bool
    private(set) var settings: Settings = Settings()
    private(set) var xCoefficient: CGFloat

    /// Initilize configuration for switcher
    /// - Parameters:
    ///     - servers: List of servers urls in strings
    ///     - current: Default preselected server. Should be equal one of servers list item. By default is first element of servers
    ///     - shouldSelectOnStart: when is true, that replaced main application window on application start, when server dont selected. Defaults is true
    public init(servers: [String], current: String? = nil, shouldSelectOnStart: Bool = true, coeffX: CGFloat = 1) {
        guard let firstServer = servers.first else {
            fatalError("Number of servers should be more than 1")
        }
        
        serversList = servers
        shouldSelectBeforeFirstScreen = shouldSelectOnStart
        currentServer = settings.savedServer ?? firstServer
        xCoefficient = coeffX
        
        if let server = current {
            currentServer = server
        }
        
        if settings.isServerShouldSave == true {
            guard let savedServer = settings.savedServer else {
                settings.savedServer = currentServer
                return
            }
            currentServer = savedServer
        }
    }
    
    mutating func currentServerUpdate(_ newServer: String) {
        currentServer = newServer
    }
}
