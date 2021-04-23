//
//  ToDoListCoordiantor+Reachable.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/23.
//

import Foundation

extension ToDoListCoordinator: ReachabilityCoordinatorDelegate {
    
    func reachabilityCoordinatorDidFinish() {
        childCoordinators[ReachabilityCoordinator] = nil
        
        viewModel?.start()
    }
}
