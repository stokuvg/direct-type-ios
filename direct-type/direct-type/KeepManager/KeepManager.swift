//
//  KeepManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/08/06.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

final public class KeepManager {
    var dicKeepStatus: [String: Bool] = [:]

    public static let shared = KeepManager()
    private init() {
    }
    
    func setKeepStatusByFetch(jobCardID: String, status: Bool) {
        dicKeepStatus[jobCardID] = status
    }
    func getKeepStatus(jobCardID: String) -> Bool {
        return dicKeepStatus[jobCardID] ?? false
    }
}
