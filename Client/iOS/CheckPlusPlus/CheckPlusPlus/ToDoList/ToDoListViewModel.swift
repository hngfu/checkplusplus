//
//  ToDoListViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import Foundation

protocol ToDoListViewModelDelegate: AnyObject {
    func showAuth()
}

final class ToDoListViewModel {
    
    weak var delegate: ToDoListViewModelDelegate?
    
    init(delegate: ToDoListViewModelDelegate) {
        self.delegate = delegate
        
        if keychainManager.getUID() == nil {
            delegate.showAuth()
        }
    }
    
    func saveUID(uid: String) {
        keychainManager.set(uid: uid)
    }
    
    //MARK: - Private
    private let keychainManager = KeychainManager()
}
