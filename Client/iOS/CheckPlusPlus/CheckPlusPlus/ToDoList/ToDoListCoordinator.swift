//
//  ToDoListCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit

final class ToDoListCoordinator: Coordinator {
    
    func start() {
        viewModel = ToDoListViewModel(delegate: self)
        
        let sb = UIStoryboard(name: "\(ToDoListViewController.self)", bundle: nil)
        guard let vc = sb.instantiateInitialViewController() as? ToDoListViewController else { return }
        navigationController.pushViewController(vc, animated: false)
    }
    
    //MARK: - Private
    var viewModel: ToDoListViewModel?
}

extension ToDoListCoordinator: ToDoListViewModelDelegate {
    
    func showAuth() {
        let authCoord = AuthCoordinator(navigationController: navigationController)
        childCoordinators[AuthCoordinator] = authCoord
        authCoord.delegate = self
        authCoord.start()
    }
}
