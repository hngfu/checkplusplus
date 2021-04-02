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
    func showAuthentication() {
        let coordinator = AuthenticationCoordinator(navigationController: navigationController)
        childCoordinators[AuthenticationCoordinator] = coordinator
        coordinator.delegate = self
        coordinator.start()
    }
}
