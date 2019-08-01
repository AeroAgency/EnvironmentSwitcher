//
//  EnvironmentSwitcher.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 24/05/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

/// Server change protocol. Say for external observers, when server was changed
public protocol EnvironmentSwitcherDelegate: class {
    func serverDidChanged(_ newServer: String)
}

// MARK: -
/// Main public class. You should init with config (ServersListConfigurator) and assign delegate
public class EnvironmentSwitcher {
    
    static var icon: UIImage {
        let bundle = Bundle(for: self)
        guard let img = UIImage(named: "domain", in: bundle, compatibleWith: nil) else {
            
            #if DEBUG
            print("ATTENTION!!! Domain swither img dont found!")
            #endif
            
            guard let coloredImg = UIImage.colored() else {
                fatalError("Image icon dont found and dont created!")
            }
            return coloredImg
        }
        return img.withRenderingMode(.alwaysTemplate)
    }
    
    private var service: SwitcherServiceInterface
    
    /// Say observers, when server was changed
    public weak var delegate: EnvironmentSwitcherDelegate?
    
    // MARK: - life cicle
    /// Initialize switcher with configuration and app container
    /// - Parameters:
    ///     - config: Configuration object with servers list and current server.
    ///     - app: Container of main app UIWindow. Default is UIApplications.shared.
    public init(_ config: ServersListConfigurator, app: MainWindowContaner = UIApplication.shared as MainWindowContaner) {
        service = SwitcherService(config: config, service: SwitcherWindowService.shared(app))
        service.delegate = self
    }
}

// MARK: - extensions
extension EnvironmentSwitcher: SwitcherServiceDelegate {
    func serverSelected(_ domain: String) {
        delegate?.serverDidChanged(domain)
    }
}
