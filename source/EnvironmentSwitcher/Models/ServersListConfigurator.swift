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

    /// init method, should contain list of servers, current selected server and flag of needed open select dialog on app start
    public init(servers: [String], current: String, shouldSelectOnStart: Bool) {
        serversList = servers
        currentServer = current
        shouldSelectBeforeFirstScreen = shouldSelectOnStart
    }
}
