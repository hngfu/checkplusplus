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
    
    private var socket: GCDAsyncSocket?
    weak var delegate: ServerSessionDelegate?
    
    override init() {
        super.init()
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: .global())
        do {
            try socket.connect(toHost: Private.Network.host,
                               onPort: Private.Network.port)
        } catch let error {
            os_log("Connect failed: %@", error.localizedDescription)
        }
        self.socket = socket
    }
    
    func registerReceive() {
        socket?.readData(withTimeout: 100, tag: 0)
    }
    
    func send(data: Data) {
        socket?.write(data, withTimeout: 100, tag: 0)
    }
    
    func disconnect() {
        socket?.disconnect()
    }
}


extension ServerSession: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        delegate?.didRead(data: data)
        registerReceive()
    }
}
