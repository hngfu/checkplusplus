//
//  RootCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import UIKit

final class RootCoordinator: Coordinator {

    func start() {
        self.viewModel = RootViewModel(delegate: self)
    }
    
    //MARK: - Private
    private var viewModel: RootViewModel?
}

extension RootCoordinator: RootViewModelDelegate {
    
    func showAuth() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators[AuthCoordinator] = coordinator
        coordinator.start()
    }
}
