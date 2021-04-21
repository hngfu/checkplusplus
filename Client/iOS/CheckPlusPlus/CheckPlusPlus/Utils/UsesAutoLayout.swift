//
//  UsesAutoLayout.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import UIKit

@propertyWrapper
struct UsesAutoLayout<T: UIView> {
    
    var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
