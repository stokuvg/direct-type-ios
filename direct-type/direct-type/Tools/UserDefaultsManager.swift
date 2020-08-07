//
//  UserDefaultsManager.swift
//  direct-type
//
//  Created by yamataku on 2020/07/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    enum Keys: String, CaseIterable {
        case isInitialDisplayedHome
        case mstCompanyKey
    }
    
    static func setObject<T>(_ value: T, key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func remove(key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAll() {
        Keys.allCases.forEach({ key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        })
        UserDefaults.standard.synchronize()
    }
    
    @discardableResult
    static func synchronize() -> Bool {
        return UserDefaults.standard.synchronize()
    }
    
    // MARK: - ホーム画面初回表示フラグ
    static var isInitialDisplayedHome: Bool {
        return UserDefaults.standard.bool(forKey: Keys.isInitialDisplayedHome.rawValue)
    }
}
