//
//  AppStartRootController.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 20/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

class AppStartRootController: UIViewController {
    
    @IBOutlet private var serverLabel: UILabel?
    
    private var currentServer: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        serverLabel?.text = currentServer
    }
    
    func setCurrentServer(_ server: String) {
        currentServer = server
        serverLabel?.text = server
    }

}
