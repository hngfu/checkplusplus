//
//  RootViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import Foundation

protocol RootViewModelDelegate: AnyObject {
    
}

final class RootViewModel {

    weak var delegate: RootViewModelDelegate?
    
    init() {
        
    }
}
