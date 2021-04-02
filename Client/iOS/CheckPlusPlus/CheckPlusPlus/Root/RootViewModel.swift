//
//  RootViewModel.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import Foundation

protocol RootViewModelDelegate: AnyObject {
    func showAuthentication()
}

final class RootViewModel {

    weak var delegate: RootViewModelDelegate?
    
    init(delegate: RootViewModelDelegate?) {
        self.delegate = delegate
        delegate?.showAuthentication()
    }
}
