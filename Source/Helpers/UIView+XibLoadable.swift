//
//  UIView+XibLoadable.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 09/08/2019.
//

import UIKit


protocol XibLoadable: UIView {
    func loadXib()
}

extension XibLoadable {
    func loadXib() {
        
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        guard let loadedView = view else {
            fatalError("Xib of \(nibName) not found and dont loaded")
        }
        
        loadedView.frame = bounds
        addSubview(loadedView)
        
        backgroundColor = .clear
    }
}
