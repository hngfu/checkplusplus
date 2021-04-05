//
//  ToDoListCoordinator+Auth.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/05.
//

import Foundation

extension ToDoListCoordinator: AuthCoordinatorDelegate {
    
    func didSignIn(uid: String) {
        childCoordinators[AuthCoordinator] = nil
        
        viewModel?.saveUID(uid: uid)
    }
}
