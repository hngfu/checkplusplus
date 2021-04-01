//
//  Coordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import UIKit

class Coordinator {
    
    let navigationController: UINavigationController
    var childCoordinators = MetaTypeDictionary<Coordinator>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
