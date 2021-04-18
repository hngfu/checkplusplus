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
        
        var getToDosMessage = C_GetToDos()
        getToDosMessage.uid = uid
        let id = UInt16(MessageID.cGetToDoList.rawValue)
        if let data = try? getToDosMessage.serializedData() {
            let packet = packetManager.makePacketWith(id: id, data: data)
            session.send(data: packet)
        }
    }
    
    //MARK: - Private
    private let keychainManager = KeychainManager()
    private let session = ServerSession()
    private let packetManager = PacketManager()
}

extension ToDoListViewModel: ServerSessionDelegate {
    
    func didRead(data: Data) {
        let (messageID, message) = packetManager.parse(packet: data)
    }
}
