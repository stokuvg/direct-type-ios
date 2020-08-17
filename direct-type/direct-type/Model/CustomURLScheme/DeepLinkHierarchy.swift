//
//  DeepLinkHierarchy.swift
//  direct-type
//
//  Created by yamataku on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

struct DeepLinkHierarchy {
    enum TabType: String, CaseIterable {
        case home
        case keep
        case myPage
        case undefined
        
        var index: Int? {
            switch self {
            case .home: return 0
            case .keep: return 1
            case .myPage: return 2
            case .undefined: return nil
            }
        }
    }
    
    enum ScreenType: String {
        case jobDetail = "job_detail"
        case approachSettings = "approach_settings"
        case undefined
    }
    
    var tabType: TabType
    var screenType: ScreenType
    var query: DeepLinkQuery
    
    init(host tabText: String, path: String, query queryText: String) {
        tabType = TabType(rawValue: tabText) ?? .undefined
        screenType = ScreenType(rawValue: path.replacingOccurrences(of: "/", with: "")) ?? .undefined
        query = DeepLinkQuery(queryText)
    }
    
    var distination: UIViewController? {
        switch screenType {
        case .jobDetail:
            let storyboad = UIStoryboard(name: "JobOfferDetailVC", bundle: nil)
            let destinationViewController = storyboad.instantiateViewController(withIdentifier: "Sbid_JobOfferDetailVC") as! JobOfferDetailVC
            destinationViewController.configure(jobId: query.jobId ?? "", isKeep: false, routeFrom: .fromHome)
            destinationViewController.hidesBottomBarWhenPushed = true
            return destinationViewController
        case .approachSettings:
            let storyboad = UIStoryboard(name: "SettingVC", bundle: nil)
            let destinationViewController = storyboad.instantiateViewController(withIdentifier: "Sbid_ApproachSettingVC")
            return destinationViewController
        case .undefined:
            return nil
        }
    }
}

struct DeepLinkQuery {
    var jobId: String?
    
    init(_ query: String) {
        if let jobIdText = query.getValue(by: "jobid") {
            jobId = jobIdText
        }
    }
}

private extension String {
    func getValue(by key: String) -> String? {
        return components(separatedBy: "&")
            .map({ $0.components(separatedBy: "=") })
            .first(where: { $0.first == key })?[1]
    }
}
