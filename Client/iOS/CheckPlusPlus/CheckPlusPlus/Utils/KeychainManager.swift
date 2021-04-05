//
//  KeychainManager.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/04.
//

import KeychainSwift
import os.log

final class KeychainManager {

    func getUID() -> String? {
        guard let uid = keychain.get(key) else { return nil }
        return Private.Keychain.decrypt(uid)
    }
    
    func set(uid: String) {
        let uid = Private.Keychain.encrypt(uid)
        if keychain.set(uid, forKey: key) == false {
            os_log("%@: '%@' is failed", #file, #function)
        }
    }
    
    func deleteUID() {
        if keychain.delete(key) == false {
            os_log("%@: '%@' is failed", #file, #function)
        }
    }
    
    //MARK: - Private
    private let keychain = KeychainSwift()
    private let key = Private.Keychain.key
}
