//
//  ToDoListCoordinator+Setting.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import Foundation

extension ToDoListCoordinator: SettingCoordinatorDelegate {
    
    func settingCoordinatorDidFinish() {
        childCoordinators[SettingCoordinator] = nil
    }
}
