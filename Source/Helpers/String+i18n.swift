//
//  String+i18n.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 07/08/2019.
//

import Foundation

/// Generate localization string for current string
public extension String {
    
    /// Try localize substring. If failed, return original string of generate fatalError in debug mode
    /// - Returns: localized string or self
    var i18n: String {
        let localized = NSLocalizedString(self, comment: "")
        
        guard localized != self else {
            #if DEBUG
                fatalError("Localization for '\(self)' string not found!")
            #endif
            return self
        }
        return localized
    }
}
