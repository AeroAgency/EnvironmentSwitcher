//
//  SwitcherService.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 11/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

// MARK: - protocols
protocol SwitcherServiceDelegate: class {
    func serverSelected(_ domain: String)
}

protocol ServersDataSource: class {
    // servers
    var current: String { get }
    var serversList: [String] { get }
    
    // settings
    var isSavingServerAvailable: Bool { get }
}

protocol PickerServersDelegate: class {
    func cancelSwitch()
    func selectedServer(_ domain: String)
}


// MARK: - interface
protocol SwitcherServiceInterface {
    var currentServer: String { get }
    var delegate: SwitcherServiceDelegate? { get set }
    
    func dispaySelectVcOnAppStartIfNeeded()
    func toggleSelectServerVc()
}


// MARK: - service
class SwitcherService: SwitcherServiceInterface {

    weak var delegate: SwitcherServiceDelegate?
    private var configurator: ServersListConfigurator
    private var windowService: SwitcherWindowService
    
    var currentServer: String {
        return current
    }
        
    // MARK: - life cicle
    init(config: ServersListConfigurator, service: SwitcherWindowService) {
        configurator = config
        windowService = service
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        guard let vc = windowService.environmentSwitcherWindow.rootViewController as? SwitcherServerSelectController else {
            fatalError("Select server view controller dont found")
        }
        
        vc.pickerDelegate = self
        vc.settingsDelegate = self
        vc.dataSource = self
        
        dispaySelectVcOnAppStartIfNeeded()
    }
    
    // MARK: selection manipulation
    func dispaySelectVcOnAppStartIfNeeded() {
        guard configurator.shouldSelectBeforeFirstScreen else {
            return
        }
        windowService.dispaySelectOnAppStartIfNeeded(configurator.shouldSelectBeforeFirstScreen, currentServer: configurator.currentServer)
    }
    
    func toggleSelectServerVc() {
        windowService.toggleSelectServerVc()
    }
    
    // MARK: notifications
    @objc private func rotated() {
        windowService.updatePositionIfNeeeded()
    }
}


// MARK: - servers list data source
extension SwitcherService: ServersDataSource {
    var current: String {
        return configurator.currentServer
    }
    
    var serversList: [String] {
        return configurator.serversList
    }
    
    var isSavingServerAvailable: Bool {
        return configurator.settings.isServerShouldSave
    }
}


// MARK: - picker select server delegate
extension SwitcherService: PickerServersDelegate {
    func cancelSwitch() {
        toggleSelectServerVc()
    }
    
    func selectedServer(_ domain: String) {
        configurator.currentServerUpdate(domain)
        toggleSelectServerVc()
        delegate?.serverSelected(domain)
        
        if configurator.settings.isServerShouldSave {
            configurator.settings.savedServer = domain
        }
    }
}


// MARK: - settings view delegate
extension SwitcherService: SettingsViewDelegate {
    func isSaveServerToggled(_ isSaveServer: Bool) {
        configurator.settings.isServerShouldSave = isSaveServer
        if isSaveServer,
            configurator.settings.savedServer == nil {
            configurator.settings.savedServer = current
        }
    }
}
