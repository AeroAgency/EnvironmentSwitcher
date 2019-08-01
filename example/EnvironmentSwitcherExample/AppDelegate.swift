//
//  AppDelegate.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 13/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        EnvironmentService.shared() // init for display select domain before start app
        return true
    }

}

