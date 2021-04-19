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
    func showCreateToDo()
}

final class ToDoListViewModel {
    
    weak var delegate: ToDoListViewModelDelegate?
    
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
    
    func addToDo() {
        delegate?.showCreateToDo()
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

    private(set) var todos = BehaviorRelay<[ToDo]>(value: [])
    private let handleQueue = DispatchQueue(label: "handleQueue")
}

extension ToDoListViewModel: ServerSessionDelegate {
    
    func didRead(data: Data) {
        let (messageID, message) = packetManager.parse(packet: data)
        messageHandler.handle(message: message, with: messageID)
    }
}

extension ToDoListViewModel: MessageHandlerDelegate {
    
    func didHandle(toDos: S_ToDos) {
        handleQueue.async { [weak self] in
            guard let `self` = self else { return }
            self.todos.accept(toDos.todos)
        }
    }
    
    func didHandle(addedToDo: S_AddedToDo) {
        handleQueue.async { [weak self] in
            guard let `self` = self else { return }
            var todo = ToDo()
            todo.id = addedToDo.id
            todo.content = addedToDo.content
            var todos = self.todos.value
            todos.append(todo)
            self.todos.accept(todos)
        }
    }
    
    func didHandle(editedToDo: S_EditedToDo) {
        handleQueue.async { [weak self] in
            guard let `self` = self else { return }
            var todos = self.todos.value
            guard let index = todos.firstIndex(where: { $0.id == editedToDo.id }) else { return }
            todos[index].content = editedToDo.content
            self.todos.accept(todos)
        }
    }
    
    func didHandle(deletedToDo: S_DeletedToDo) {
        handleQueue.async { [weak self] in
            guard let `self` = self else { return }
            var todos = self.todos.value
            todos = todos.filter { $0.id != deletedToDo.id }
            self.todos.accept(todos)
        }
    }
}
