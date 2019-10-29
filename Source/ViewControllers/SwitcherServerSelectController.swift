//
//  SwitcherServerSelectController.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 11/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

// MARK: - controller declaratiom
class SwitcherServerSelectController: UIViewController {
    
    @IBOutlet private var serverPicker: UIPickerView?
    @IBOutlet private var settingsView: SettingsView?
    @IBOutlet private var toolbarView: UIToolbar?
    
    weak var settingsDelegate: SettingsViewDelegate?
    weak var pickerDelegate: PickerServersDelegate?
    weak var dataSource: ServersDataSource? {
        didSet {
            serverPicker?.reloadAllComponents()
            selectCurrentServer()
            updateSettingsView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectCurrentServer()
        updateSettingsView()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if #available(iOS 13.0, *) {// Hack. In ios 13 buttons setted on storyboard invisible, but in iOS 10,11,12 - invisible buttons setted in this code
            let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancelButton))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
            toolbarView?.setItems([cancel, space, done], animated: true)
        }
        
    }
    
    private func selectCurrentServer() {
        guard let source = dataSource,
            let index = source.serversList.firstIndex(of: source.current) else {
                return
        }
        serverPicker?.selectRow(index, inComponent: 0, animated: true)
    }
    
    private func updateSettingsView() {
        settingsView?.setIsSavingServer(dataSource?.isSavingServerAvailable ?? false)
    }
}

// MARK: - actions
private extension SwitcherServerSelectController {
    @IBAction @objc private func tapCancelButton() {
        pickerDelegate?.cancelSwitch()
    }
    
    @IBAction @objc private func tapDoneButton() {
        guard let picker = serverPicker else {
            return
        }
        
        let selectedRow = picker.selectedRow(inComponent: 0)
        
        guard let serverDomain = pickerView(picker, titleForRow: selectedRow, forComponent: 0) else {
            return
        }
        
        pickerDelegate?.selectedServer(serverDomain)
    }
}

// MARK: - picker view data source
extension SwitcherServerSelectController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.serversList.count ?? 0
    }
    
}

// MARK: - picker view delegate
extension SwitcherServerSelectController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let list = dataSource?.serversList else {
            return "-"
        }
        
        return list[row]
        
    }
}

// MARK: - settigns view delegate
extension SwitcherServerSelectController: SettingsViewDelegate {
    func isSaveServerToggled(_ isSaveServer: Bool) {
        settingsDelegate?.isSaveServerToggled(isSaveServer)
    }
}
