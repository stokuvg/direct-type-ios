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
    static func track(type: AnalyticsEventType) {
        AppsFlyerTracker.shared().trackEvent(type.log, withValues: nil)
    }
    
    static func setUser(by id: String) {
        AppsFlyerTracker.shared().customerUserID = id
    }
}
