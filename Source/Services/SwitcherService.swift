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
    var current: String { get }
    func serversList() -> [String]
}

protocol PickerServersDelegate: class {
    func cancelSwitch()
    func selectedServer(_ domain: String)
}

// MARK: - interface
protocol SwitcherServiceInterface {
    var delegate: SwitcherServiceDelegate? { get set }
    
    func dispaySelectVcOnAppStartIfNeeded()
    func toggleSelectServerVc()
}

// MARK: - service
class SwitcherService: SwitcherServiceInterface {

    weak var delegate: SwitcherServiceDelegate?
    private var configurator: ServersListConfigurator
    private var windowService: SwitcherWindowService
        
    // MARK: - life cicle
    init(config: ServersListConfigurator, service: SwitcherWindowService) {
        configurator = config
        windowService = service
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        guard let vc = windowService.environmentSwitcherWindow.rootViewController as? SwitcherServerSelectController else {
            fatalError("Select server view controller dont found")
        }
        
        vc.delegate = self
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
    func serversList() -> [String] {
        return configurator.serversList
    }
}

// MARK: - switcher delegate
extension SwitcherService: PickerServersDelegate {
    func cancelSwitch() {
        toggleSelectServerVc()
    }
    
    func selectedServer(_ domain: String) {
        toggleSelectServerVc()
        delegate?.serverSelected(domain)
    }
}
