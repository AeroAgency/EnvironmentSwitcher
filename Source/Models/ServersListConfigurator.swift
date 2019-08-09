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

    private(set) var serversList: [String]
    private(set) var currentServer: String
    private(set) var shouldSelectBeforeFirstScreen: Bool
    private(set) var settings: Settings = Settings()

    /// Initilize configuration for switcher
    /// - Parameters:
    ///     - servers: List of servers urls in strings
    ///     - current: Default preselected server. Should be equal one of servers list item
    ///     - shouldSelectOnStart: when is true, that replaced main application window on application start, when server dont selected. Defaults is true
    public init(servers: [String], current: String?, shouldSelectOnStart: Bool = true) {
        guard let firstServer = servers.first else {
            fatalError("Numbber of servers dont can empty")
        }
        
        serversList = servers
        shouldSelectBeforeFirstScreen = shouldSelectOnStart
        currentServer = settings.savedServer ?? firstServer
        
        guard let server = current else {
            return
        }
        currentServer = server
    }
}
