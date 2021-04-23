//
//  NetworkStatus.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/23.
//

import Foundation

final class NetworkStatus {
    
    static let `default` = NetworkStatus()
    
    var isConnected: Bool {
        return reachability.currentReachabilityStatus() != NotReachable
    }
    
    //MARK: - Private
    private let reachability: Reachability
    
    private init() {
        reachability = Reachability.forInternetConnection()
        reachability.startNotifier()
    }
}
