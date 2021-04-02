//
//  AuthenticationCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    
}

final class AuthenticationCoordinator: Coordinator {
    
    weak var delegate: AuthenticationCoordinatorDelegate?
    
    func start() {
        let vc = UIViewController(nibName: "AuthenticationViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - Private
    private var viewModel: AuthenticationViewModel?
}
