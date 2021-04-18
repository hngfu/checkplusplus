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
        var packet = Data(bytes: &id, count: MemoryLayout.size(ofValue: id))
        packet.append(data)
        return packet
    }
}
