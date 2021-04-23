//
//  ReachableConnectionViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/23.
//

import Foundation

protocol ReachabilityViewModelDelegate: AnyObject {
    func reachabilityDidConnected()
}

final class ReachabilityViewModel {
    
    weak var delegate: ReachabilityViewModelDelegate?
    
    //MARK: - Private & init
    private let networkStatus = NetworkStatus.default
    
    @objc private func didChangeReachability() {
        guard networkStatus.isConnected else { return }
        delegate?.reachabilityDidConnected()
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeReachability),
                                               name: .reachabilityChanged, object: nil)
    }
}
