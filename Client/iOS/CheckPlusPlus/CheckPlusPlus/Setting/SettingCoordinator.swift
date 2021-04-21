//
//  SettingCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import UIKit

protocol SettingCoordinatorDelegate: AnyObject {
    func settingCoordinatorDidFinish()
}

final class SettingCoordinator: Coordinator {
    
    weak var delegate: SettingCoordinatorDelegate?
    
    func start() {
        let sb = UIStoryboard(name: "\(SettingViewController.self)", bundle: nil)
        guard let nc = sb.instantiateInitialViewController() as? UINavigationController,
              let vc = nc.topViewController as? SettingViewController else { return }
        vc.viewModel = viewModel
        nc.modalPresentationStyle = .fullScreen
        navigationController.present(nc, animated: true)
    }
    
    //MARK: - Private
    private let viewModel = SettingViewModel()
}

extension SettingCoordinator: SettingViewModelDelegate {
    
    func settingViewModelDidSetOptions() {
        delegate?.settingCoordinatorDidFinish()
    }
}
