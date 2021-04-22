//
//  SettingViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import Foundation

protocol SettingViewModelDelegate: AnyObject {
    func settingViewModelDidSetOptions()
}

final class SettingViewModel {
    
    weak var delegate: SettingViewModelDelegate?
    
    func change(settingValue: Bool, with key: Setting.Key) {
        Setting.shared.change(settingValue: settingValue, with: key)
    }
    
    func finish() {
        delegate?.settingViewModelDidSetOptions()
    }
}

final class Setting {
    
    static let shared = Setting()
    
    func setting(with key: Setting.Key) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }
    
    fileprivate func change(settingValue: Bool, with key: Setting.Key) {
        userDefaults.set(settingValue, forKey: key.rawValue)
    }
    
    //MARK: - Private
    private init() {
        if userDefaults.object(forKey: Key.isFirstLaunch.rawValue) == nil {
            userDefaults.set(true, forKey: Key.isFirstLaunch.rawValue)
        }
        let isFirstLaunch = userDefaults.bool(forKey: Key.isFirstLaunch.rawValue)
        if isFirstLaunch {
            //Set default values
            userDefaults.set(true, forKey: Key.shouldCheckAgainToDoCompletion.rawValue)
            userDefaults.set(true, forKey: Key.shouldShowCheeringCard.rawValue)
            
            userDefaults.set(false, forKey: Key.isFirstLaunch.rawValue)
        }
    }
    
    private let userDefaults: UserDefaults = .standard
    
    //MARK: - Key
    enum Key: String {
        case shouldCheckAgainToDoCompletion = "shouldCheckAgainToDoCompletion"
        case shouldShowCheeringCard = "shouldShowCheeringCard"
        
        case isFirstLaunch = "isFirstLaunch"
    }
}

