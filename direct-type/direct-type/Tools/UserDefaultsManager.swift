//
//  UserDefaultsManager.swift
//  direct-type
//
//  Created by yamataku on 2020/07/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    enum Keys: String {
        case isDisplayHome
        case isPushTab
        case mstCompanyKey
    }
    
    static let shared = UserDefaultsManager()
    
    func setObject<T>(_ value: T, key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func remove(key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    @discardableResult
    func synchronize() -> Bool {
        return UserDefaults.standard.synchronize()
    }
    
    // MARK: - ホーム画面表示フラグ
    var isDisplayHome: Bool {
        return UserDefaults.standard.bool(forKey: Keys.isDisplayHome.rawValue)
    }
    
    // MARK: - プッシュタブ画面表示フラグ
    var isPushTab: Bool {
        return UserDefaults.standard
            .bool(forKey: Keys.isPushTab.rawValue)
    }
}
