//
//  UIViewController+fromNib.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 11/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

extension UIViewController {
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        return self.init(nibName: String(describing: self.self), bundle: bundle)
    }
}
