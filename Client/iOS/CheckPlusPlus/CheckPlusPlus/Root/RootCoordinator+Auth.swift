//
//  RootCoordinator+Auth.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/04.
//

import Foundation

extension RootCoordinator: AuthCoordinatorDelegate {
    
    func showToDoList(with uid: String) {
        let coordinator = ToDoListCoordinator(navigationController: navigationController)
        childCoordinators[ToDoListCoordinator] = coordinator
        coordinator.start(with: uid)
    }
}
