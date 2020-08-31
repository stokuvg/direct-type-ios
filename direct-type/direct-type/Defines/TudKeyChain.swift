//
//  TudKeyChain.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/08/31.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import KeychainAccess

public enum TudKeyChain {
    case accept
    case password(email: String)

    var bufKey: String {
        let sub: String = AuthManager.shared.sub
        switch self {
        case .accept:
            return "accept_\(sub)"
        case .password(email: let email):
            return "pwd_\(sub)_\(email)"
        }
    }
    public func set(_ value: String) {
        let keychain: Keychain = Keychain() //無視定でBundleIDが適用される
        keychain[bufKey] = value
  }
    public func value() -> String? {
        let keychain: Keychain = Keychain() //無視定でBundleIDが適用される
        if let bufValue = try? keychain.getString(bufKey) {
            return bufValue
        } else {
            return nil
        }
    }
}

