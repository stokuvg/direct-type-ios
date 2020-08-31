//
//  TudKeyChain.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/08/31.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import Security

public enum TudKeyChain {
    case password(sub: String, email: String)

    var bufKey: String {
        switch self {
        case .password(sub: let sub, email: let email):
            return "password_\(sub)_\(email)"
        }
    }

    public func set(_ key: String, _ value: String) {
        let query: [String: AnyObject] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: self.bufKey as AnyObject,
        kSecValueData as String: value.data(using: .utf8)! as AnyObject
    ]
    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }
    public func value() -> String? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: self.bufKey as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == noErr else { return nil }
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

