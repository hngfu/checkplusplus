//
//  ReachableConnectionCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/23.
//

import Foundation

protocol ReachabilityCoordinatorDelegate: AnyObject {
    func reachabilityCoordinatorDidFinish()
}

final class ReachabilityCoordinator: Coordinator {
    
    weak var delegate: ReachabilityCoordinatorDelegate?
    
    func start() {
        let viewModel = ReachabilityViewModel()
        viewModel.delegate = self
        let vc = ReachabilityViewController(nibName: "\(ReachabilityViewController.self)", bundle: nil)
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .fullScreen
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: true, completion: nil)
        }
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Private
    private let viewModel = ReachabilityViewModel()
}

extension ReachabilityCoordinator: ReachabilityViewModelDelegate {
    
    func reachabilityDidConnected() {
        navigationController.dismiss(animated: true, completion: nil)
        delegate?.reachabilityCoordinatorDidFinish()
    }
}
