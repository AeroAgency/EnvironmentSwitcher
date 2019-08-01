//
//  ModalController.swift
//  EnvironmentSwitcherExample
//
//  Created by Stas on 14/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

class ModalController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction private func close() {
        dismiss(animated: true, completion: nil)
    }

}
