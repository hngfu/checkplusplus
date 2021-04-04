//
//  RootViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import Foundation

protocol RootViewModelDelegate: AnyObject {
    func showAuth()
    func showToDoList(with uid: String)
}

final class RootViewModel {

    weak var delegate: RootViewModelDelegate?
    
    init(delegate: RootViewModelDelegate?) {
        self.delegate = delegate
        
        if let uid = keychainManager.getUID() {
            delegate?.showToDoList(with: uid)
        } else {
            delegate?.showAuth()
        }
    }
    
    //MARK: - Private
    private let keychainManager = KeychainManager.shared
}
