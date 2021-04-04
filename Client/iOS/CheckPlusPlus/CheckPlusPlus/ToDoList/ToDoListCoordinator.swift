//
//  ToDoListCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit

final class ToDoListCoordinator: Coordinator {
    
    func start(with uid: String) {
        let sb = UIStoryboard(name: "ToDoListViewController", bundle: nil)
        guard let vc = sb.instantiateInitialViewController() as? ToDoListViewController else { return }
        vc.uid = uid
        navigationController.pushViewController(vc, animated: false)
    }
    
    //MARK: - Private
    private var viewModel: ToDoListViewModel?
}
