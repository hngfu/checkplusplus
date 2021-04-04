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
        showToDoList()
    }
    
    //MARK: - Private
    private var viewModel: RootViewModel?
    
    private func showToDoList() {
        let coordinator = ToDoListCoordinator(navigationController: navigationController)
        childCoordinators[ToDoListCoordinator] = coordinator
        coordinator.start()
    }
}

extension RootCoordinator: RootViewModelDelegate {
    func showAuth() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators[AuthCoordinator] = coordinator
        coordinator.start()
    }
}
