//
//  ToDoListViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import Foundation
import RxRelay

protocol ToDoListViewModelDelegate: AnyObject {
    func showAuth()
}

final class ToDoListViewModel {
    
    weak var delegate: ToDoListViewModelDelegate?
    var todos = BehaviorRelay<[ToDo]>(value: [])
    
    init(delegate: ToDoListViewModelDelegate) {
        self.delegate = delegate
        session.delegate = self
        
        if keychainManager.getUID() == nil {
            delegate.showAuth()
        }
    }
    
    func start(with uid: String) {
        keychainManager.set(uid: uid)
    }
    
    //MARK: - Private
    private let keychainManager = KeychainManager()
    private let session = ServerSession()
}

extension ToDoListViewModel: ServerSessionDelegate {
    
    func didRead(data: Data) {
        
    }
}
