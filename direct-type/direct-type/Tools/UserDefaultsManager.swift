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
        case profileFetchDate
        case mstCompanyKey
    }
    
    static let shared = UserDefaultsManager()
    
    func setObject<T>(_ value: T, key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func remove(key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func removeAll() {
        Keys.allCases.forEach({ key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        })
        UserDefaults.standard.synchronize()
    }
    
    @discardableResult
    func synchronize() -> Bool {
        return UserDefaults.standard.synchronize()
    }
    
    // MARK: - ホーム画面初回表示フラグ
    var isInitialDisplayedHome: Bool {
        return UserDefaults.standard.bool(forKey: Keys.isInitialDisplayedHome.rawValue)
    }
    
    // MARK: - 最後にプロフィールデータを取得した日付
    var profileFetchDate: Date? {
        return UserDefaults.standard.object(forKey: Keys.profileFetchDate.rawValue) as? Date
    }
}
