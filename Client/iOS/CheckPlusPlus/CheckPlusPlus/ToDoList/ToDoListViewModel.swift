//
//  ToDoListViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import Foundation
import RxRelay
import SwiftProtobuf

protocol ToDoListViewModelDelegate: AnyObject {
    func showAuth()
    func showSetting()
    func showReachability()
}

final class ToDoListViewModel {
    
    weak var delegate: ToDoListViewModelDelegate?
    
    init(delegate: ToDoListViewModelDelegate) {
        self.delegate = delegate
        session.delegate = self
        messageHandler.delegate = self
    
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeReachability),
                                               name: .reachabilityChanged, object: nil)
    }
    
    func start() {
        guard networkStatus.isConnected else {
            self.delegate?.showReachability()
            return
        }
        guard let uid = keychainManager.getUID() else {
            self.delegate?.showAuth()
            return
        }

        session.connect()
        var message = C_GetToDos()
        message.uid = uid
        send(message: message, with: .cGetToDoList)
    }
    
    func addToDo(with content: String) {
        var message = C_AddToDo()
        message.content = content
        send(message: message, with: .cAddToDo)
    }
    
    func editToDo(with id: Int32, content: String) {
        var message = C_EditToDo()
        message.content = content
        message.id = id
        send(message: message, with: .cEditToDo)
    }
    
    func deleteToDo(with id: Int32) {
        var message = C_DeleteToDo()
        message.id = id
        send(message: message, with: .cDeleteToDo)
    }
    
    func setOptions() {
        delegate?.showSetting()
    }
    
    func save(uid: String) {
        keychainManager.set(uid: uid)
    }
    
    //MARK: - Private & deinit
    private let keychainManager = KeychainManager()
    private let session = ServerSession()
    private let packetManager = PacketManager()
    private let messageHandler = MessageHandler()
    private let networkStatus = NetworkStatus.default

    private(set) var todos = BehaviorRelay<[ToDo]>(value: [])
    private let handleQueue = DispatchQueue(label: "handleQueue")
    
    private func send(message: Message, with id: MessageID) {
        let messageID = UInt16(id.rawValue)
        if let data = try? message.serializedData() {
            let packet = packetManager.makePacketWith(id: messageID, data: data)
            session.send(data: packet)
        }
    }
    
    @objc private func didChangeReachability() {
        guard networkStatus.isConnected == false else { return }
        delegate?.showReachability()
    }
    
    deinit {
        session.disconnect()
    }
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
