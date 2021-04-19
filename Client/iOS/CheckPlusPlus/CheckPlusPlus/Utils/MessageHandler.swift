//
//  MessageHandler.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/19.
//

import Foundation

protocol MessageHandlerDelegate: AnyObject {
    func didHandle(toDos: S_ToDos)
    func didHandle(addedToDo: S_AddedToDo)
    func didHandle(editedToDo: S_EditedToDo)
    func didHandle(deletedToDo: S_DeletedToDo)
}

final class MessageHandler {
    
    weak var delegate: MessageHandlerDelegate?
    
    func handle(message: Data, with id: UInt16) {
        
        guard let messageID = MessageID(rawValue: Int(id)) else { return }
        switch messageID {
        case .sToDos:
            guard let message = try? S_ToDos(serializedData: message) else { return }
            delegate?.didHandle(toDos: message)
        case .sAddedToDo:
            guard let message = try? S_AddedToDo(serializedData: message) else { return }
            delegate?.didHandle(addedToDo: message)
        case .sEditedToDo:
            guard let message = try? S_EditedToDo(serializedData: message) else { return }
            delegate?.didHandle(editedToDo: message)
        case .sDeletedToDo:
            guard let message = try? S_DeletedToDo(serializedData: message) else { return }
            delegate?.didHandle(deletedToDo: message)
        default:
            return
        }
    }
}
