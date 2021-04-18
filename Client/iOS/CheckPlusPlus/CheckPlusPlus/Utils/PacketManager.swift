//
//  PacketManager.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/18.
//

import Foundation

final class PacketManager {
    
    func makePacketWith(id: UInt16, data: Data) -> Data {
        var id = id
        var packet = Data(bytes: &id, count: messageIDHeaderSize)
        packet.append(data)
        return packet
    }
    
    func parse(packet: Data) -> (messageID: UInt16, message: Data) {
        let idHeader = Data(packet[0..<messageIDHeaderSize])
        let messageID = idHeader.withUnsafeBytes { $0.load(as: UInt16.self) }
        return (messageID, packet[2..<packet.count])
    }
    
    //MARK: - Private
    private let messageIDHeaderSize = 2
}
