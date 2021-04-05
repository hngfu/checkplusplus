//
//  RootCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import UIKit

final class RootCoordinator: Coordinator {

    func start() {
        let coordinator = ToDoListCoordinator(navigationController: navigationController)
        childCoordinators[ToDoListCoordinator] = coordinator
        coordinator.start()
    }
}
