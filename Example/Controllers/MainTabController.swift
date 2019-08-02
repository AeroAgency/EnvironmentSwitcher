//
//  MainTabController.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 13/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

class MainTabController: UIViewController, EnvironmentListener {

    @IBOutlet private var serverNameLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverNameLabel?.text = EnvironmentService.shared().currentServer
        
        startEnvironmentListen()
    }
    
    // MARK: server changing detection
    func startEnvironmentListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNewServerName), name: .serverChanged, object: nil)
    }
    
    func shouldChangeServerTo(_ newServer: String) {
        serverNameLabel?.text = newServer
    }
    
    @objc func getNewServerName(_ notification: Notification) {
        guard let newDomain = fetchDomainFromNotification(notification) else {
            return
        }
        shouldChangeServerTo(newDomain)
    }
    
}
