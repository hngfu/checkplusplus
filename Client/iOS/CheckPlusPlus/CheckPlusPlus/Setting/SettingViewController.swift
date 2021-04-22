//
//  SettingViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import UIKit

final class SettingViewController: UITableViewController {
    
    @IBOutlet weak var checkAgainSwitch: UISwitch!
    @IBOutlet weak var showCheeringCardSwitch: UISwitch!
    
    var viewModel: SettingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAgainSwitch.isOn = Setting.shared.setting(with: .shouldCheckAgainToDoCompletion)
        showCheeringCardSwitch.isOn = Setting.shared.setting(with: .shouldShowCheeringCard)
    }
    
    @IBAction func tapCloseButton(_ sender: UIBarButtonItem) {
        viewModel?.finish()
    }

    @IBAction func toggleCheckAgainSwitch(_ sender: UISwitch) {
        viewModel?.change(settingValue: sender.isOn, with: .shouldCheckAgainToDoCompletion)
    }
    
    @IBAction func toggleShowCheeringCardSwitch(_ sender: UISwitch) {
        viewModel?.change(settingValue: sender.isOn, with: .shouldShowCheeringCard)
    }
}
