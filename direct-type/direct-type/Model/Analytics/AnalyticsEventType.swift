//
//  AnalyticsEventType.swift
//  direct-type
//
//  Created by yamataku on 2020/07/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import AppsFlyerLib

enum AnalyticsEventType {
    case createAuthenticationCode
    case confirmAuthCode
    case keep
    case skipVacancies
    case entryJob
    case completeEntry
    case logout
    case withdrawal
    case viewHome
    case viewVacancies
    case viewKeep
    
    private var debugLogSuffix: String {
        return "_test"
    }
    
    var log: String {
        var text = ""
        switch self {
        case .createAuthenticationCode:
            text =  "create_authentication_code"
        case .confirmAuthCode:
            text =  "confirm_auth_code"
        case .keep:
            text =  "keep"
        case .skipVacancies:
            text =  "skip_vacancies"
        case .entryJob:
            text =  "entry_job"
        case .completeEntry:
            text =  "complete_entry"
        case .logout:
            text =  "logout"
        case .withdrawal:
            text =  "withdrawal"
        case .viewHome:
            text =  "view_home"
        case .viewVacancies:
            text =  "view_vacancies"
        case .viewKeep:
            text =  "view_keep"
        }
        if AppDefine.isDebugForAppsFlyer {
            text += debugLogSuffix
        }
        return text
    }
}
