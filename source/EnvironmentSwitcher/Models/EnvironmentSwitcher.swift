//
//  EnvironmentSwitcher.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 24/05/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

/// Server change protocol. Say for external observers, when server was changed
/// How it works - see example folder
public protocol EnvironmentSwitcherDelegate: class {
    func serverDidChanged(_ newServer: String)
}

// MARK: -
/// Main public class. You should init with config (ServersListConfigurator) and assign delegate
public class EnvironmentSwitcher {
    
    static var icon: UIImage {
        let bundle = Bundle(for: self)
        guard let img = UIImage(named: "domain", in: bundle, compatibleWith: nil) else {
//            fatalError("Image icon not found!")
            print("domain img dont found!!!")
            let rect = CGRect(origin: .zero, size: CGSize(width: 38, height: 38))
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            UIColor.red.setFill()
            UIRectFill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let cgImage = image?.cgImage else {
                fatalError("Image icon not found and dont created!")
            }
            return UIImage(cgImage: cgImage)
        }
        return img.withRenderingMode(.alwaysTemplate)
    }
    
    private var service: SwitcherServiceInterface
    
    /// Main delegate, say observers, when server was changed
    public weak var delegate: EnvironmentSwitcherDelegate?
    
    // MARK: - life cicle
    /// init, should initiated whith configuration
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
