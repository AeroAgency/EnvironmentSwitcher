//
//  Settings.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 09/08/2019.
//

import Foundation

class Settings {
    
    private enum SettingsUserDefaultsKeys {
        static let isServerSavedKey = "SettingsUserDefaultsKeys.isServerSavedKey"
        static let lastSelectedServer = "SettingsUserDefaultsKeys.lastSelectedServer"
    }
    
    
    dynamic var isServerShouldSave: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsUserDefaultsKeys.isServerSavedKey)
            (newValue == false) ? savedServer = nil : nil
        }
        
        get {
            let savedValue = UserDefaults.standard.value(forKey: SettingsUserDefaultsKeys.isServerSavedKey) as? Bool
            return savedValue ?? true
        }
    }
    
    dynamic var savedServer: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsUserDefaultsKeys.lastSelectedServer)
        }
        
        get {
            let savedValue = UserDefaults.standard.value(forKey: SettingsUserDefaultsKeys.lastSelectedServer) as? String
            return savedValue
        }
    }
}
