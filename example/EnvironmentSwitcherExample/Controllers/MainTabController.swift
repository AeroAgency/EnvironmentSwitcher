//
//  MainTabController.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 13/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

class MainTabController: UIViewController, EvironmentListener {

    @IBOutlet private weak var serverNameLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverNameLabel?.text = EnvironmentService.shared().currentServer
        
        startEnvironmentListen()
    }
    
    // MARK: server changing detection
    func startEnvironmentListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNewServerName), name: .serverChanged, object: nil)
    }
    
    func shouldChangeServer(newServer: String) {
        print("MainTabController should change")
    }
    
    @objc private func getNewServerName(_ notification: Notification) {
        guard let newDomain = notification.userInfo?[Notification.Name.serverChanged] as? String else {
            serverNameLabel?.text = "Не удалось получить новый адрес сервера"
            return
        }
        serverNameLabel?.text = newDomain
    }
    
}

