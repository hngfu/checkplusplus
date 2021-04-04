//
//  AuthPickerViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/04.
//

import UIKit
import FirebaseUI

class AuthPickerViewController: FUIAuthPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil
    }
}
