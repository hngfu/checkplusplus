//
//  ServerSession.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/15.
//

import Foundation
import CocoaAsyncSocket
import os.log

protocol ServerSessionDelegate: AnyObject {
    func didRead(data: Data)
}

final class ServerSession: NSObject {
    
    private lazy var socket = GCDAsyncSocket(delegate: self, delegateQueue: .global())
    weak var delegate: ServerSessionDelegate?

    func connect() {
        do {
            if socket.isConnected {
                disconnect()
            }
            try socket.connect(toHost: Private.Network.host,
                               onPort: Private.Network.port)
            registerReceive()
        } catch let error {
            os_log("Connect failed: %@", error.localizedDescription)
        }
    }
    
    func send(data: Data) {
        socket.write(data, withTimeout: 100, tag: 0)
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    //MARK: - Private
    private func registerReceive() {
        socket.readData(withTimeout: -1, tag: 0)
    }
}

extension ServerSession: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        delegate?.didRead(data: data)
        registerReceive()
    }
}
