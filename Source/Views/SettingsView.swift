//
//  SettingsView.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 09/08/2019.
//

import UIKit

protocol SettingsViewDelegate: class {
    func isSaveServerToggled(_ isSaveServer: Bool)
}

class SettingsView: UIView, XibLoadable {
    
    @IBOutlet private var saveServerLabel: UILabel?
    @IBOutlet private var isSaveServerSwitch: UISwitch?
    
    //swiftlint:disable strong_iboutlet
    @IBOutlet private weak var ibDelegate: AnyObject?
    /// object for AEROTextFieldViewDelegate protocol
    dynamic var delegate: SettingsViewDelegate? {
        set { ibDelegate = newValue }
        get { return ibDelegate as? SettingsViewDelegate }
    }
    //swiftlint:enable strong_iboutlet
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadXib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadXib()
    }

    func setIsSavingServer(_ isSaving: Bool) {
        isSaveServerSwitch?.isOn = isSaving
    }
}

extension SettingsView {
    @IBAction private func isSaveServerSwitchToggled() {
        delegate?.isSaveServerToggled(isSaveServerSwitch?.isOn ?? true)
    }
}
