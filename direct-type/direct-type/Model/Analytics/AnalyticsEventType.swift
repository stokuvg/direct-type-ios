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
    // アクションイベント系
    case createAuthenticationCode
    case confirmAuthCode
    case keep
    case skipVacancies
    case entryJob
    case completeEntry
    case logout
    case withdrawal
    // 画面表示イベント系
    case viewHome
    case viewVacancies
    case viewKeepList
    // 画面遷移経路イベント系
    case transitionPath(destination: RouteDestinationType, from: RouteFromType)
    
    enum RouteDestinationType {
        case toJobDetail
        case toEntryDetail
        
        var eventName: String {
            switch self {
            case .toJobDetail:
                return "to_job_detail"
            case .toEntryDetail:
                return "to_entry"
            }
        }
    }
    
    enum RouteFromType {
        case unknown
        case fromHome
        case fromKeepList
        
        var suffix: String {
            switch self {
            case .fromHome:
                return "_from_home"
            case .fromKeepList:
                return "_from_keep_list"
            case .unknown:
                return ""
            }
        }
    }
    
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
        case .viewKeepList:
            text =  "view_keep_list"
        case .transitionPath(let destination, let from):
            text = destination.eventName + from.suffix
        }
        if AppDefine.isDebugForAppsFlyer {
            text += debugLogSuffix
        }
        return text
    }
}
