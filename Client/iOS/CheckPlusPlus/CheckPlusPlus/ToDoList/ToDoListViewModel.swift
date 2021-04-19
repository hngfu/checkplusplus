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
        messageHandler.delegate = self
        
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
    
    func deleteToDo(with id: Int32) {
        var message = C_DeleteToDo()
        message.id = id
        let messageID = UInt16(MessageID.cDeleteToDo.rawValue)
        if let data = try? message.serializedData() {
            let packet = packetManager.makePacketWith(id: messageID, data: data)
            session.send(data: packet)
        }
    }
    
    //MARK: - Private
    private let keychainManager = KeychainManager()
    private let session = ServerSession()
    private let packetManager = PacketManager()
    private let messageHandler = MessageHandler()
    
    private var _todos = [ToDo]()
}

extension ToDoListViewModel: ServerSessionDelegate {
    
    func didRead(data: Data) {
        let (messageID, message) = packetManager.parse(packet: data)
        messageHandler.handle(message: message, with: messageID)
    }
}

extension ToDoListViewModel: MessageHandlerDelegate {
    
    func didHandle(toDos: S_ToDos) {
        _todos = toDos.todos
        acceptToDos()
    }
    
    func didHandle(addedToDo: S_AddedToDo) {
        var todo = ToDo()
        todo.id = addedToDo.id
        todo.content = addedToDo.content
        _todos.append(todo)
        acceptToDos()
    }
    
    func didHandle(editedToDo: S_EditedToDo) {
        guard let index = _todos.firstIndex(where: { $0.id == editedToDo.id }) else { return }
        _todos[index].content = editedToDo.content
        acceptToDos()
    }
    
    func didHandle(deletedToDo: S_DeletedToDo) {
        _todos = _todos.filter { $0.id != deletedToDo.id }
        acceptToDos()
    }
    
    private func acceptToDos() {
        todos.accept(_todos)
    }
}
