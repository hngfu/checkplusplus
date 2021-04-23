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
    @IBOutlet weak var logoutButton: UIButton!
    
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logoutIndexPath = IndexPath(row: 0, section: 2)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == logoutIndexPath && logoutButton.isEnabled {
            let alertController = createLogoutAlertControlelr()
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Private
    private func createLogoutAlertControlelr() -> UIAlertController {
        let alertController = UIAlertController(title: nil,
                                                message: "로그아웃하시겠습니까?",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
            self.logoutButton.isEnabled = false
            self.viewModel?.logout()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
