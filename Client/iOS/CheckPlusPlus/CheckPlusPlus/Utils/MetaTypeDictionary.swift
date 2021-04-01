//
//  MetaTypeDictionary.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/01.
//

import Foundation

struct MetaTypeDictionary<Type> {
    subscript(key: Type.Type) -> Type? {
        get {
            return dictionary[ObjectIdentifier(key)]
        }
        set(newValue) {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
    
    private var dictionary = [ObjectIdentifier: Type]()
}
