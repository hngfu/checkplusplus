//
//  SettingCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import UIKit

protocol SettingCoordinatorDelegate: AnyObject {
    
}

final class SettingCoordinator: Coordinator {
    
    weak var delegate: SettingCoordinatorDelegate?
    
    func start() {
        let vc = SettingViewController(nibName: "\(SettingViewController.self)", bundle: nil)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK: - Private
    private let viewModel = SettingViewModel()
}
