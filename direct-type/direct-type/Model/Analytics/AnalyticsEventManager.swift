//
//  AnalyticsEventManager.swift
//  direct-type
//
//  Created by yamataku on 2020/07/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import AppsFlyerLib

class AnalyticsEventManager {
    static func track(type: AnalyticsEventType, with parameter: [AnyHashable : Any]? = nil) {
        AppsFlyerTracker.shared().trackEvent(type.log, withValues: parameter)
    }
    
    // 初回リリース時にはユーザーIDの考慮はしない。が今後適用する際にはこのメソッドを利用してユーザーIDをセットする。
    static func setUser(by id: String?) {
        AppsFlyerTracker.shared().customerUserID = id
    }
}
