//
//  DeepLinkHierarchy.swift
//  direct-type
//
//  Created by yamataku on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

struct DeepLinkHierarchy {
    enum ScreenType: String {
        case jobDetail = "job_detail"
        case approachSettings = "approach_settings"
        case undefined
    }
    
    private var actionType: ActionType
    var screenType: ScreenType
    var query: DeepLinkQuery
    
    init(host: String, path: String, query queryText: String) {
        actionType = ActionType(rawValue: host) ?? .view
        let pathList = path.split(separator: "/").map({String($0)})
        screenType = ScreenType(rawValue: pathList.first ?? "") ?? .undefined
        query = DeepLinkQuery(queryText)
    }

    
    var rootNavigation: UINavigationController? {
        guard let rootTabBarController = UIApplication.shared.keyWindow?
            .rootViewController as? UITabBarController,
        let tabIndex = tabType.index else { return nil }
        rootTabBarController.selectedIndex = tabIndex
        return rootTabBarController.children[tabIndex] as? UINavigationController
    }
    
    var distination: UIViewController? {
        switch screenType {
        case .jobDetail:
            let storyboad = UIStoryboard(name: "JobOfferDetailVC", bundle: nil)
            let destinationViewController = storyboad.instantiateViewController(withIdentifier: "Sbid_JobOfferDetailVC") as! JobOfferDetailVC
            destinationViewController.configure(jobId: query.jobId ?? "", routeFrom: .smsScout)
            destinationViewController.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする
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

private extension DeepLinkHierarchy {
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
    
    var tabType: TabType {
        // 遷移先画面からルートとなるタブを内部的に判定する
        switch screenType {
        case .jobDetail:
            return .home
        case .approachSettings:
            return .myPage
        case .undefined:
            return .undefined
        }
    }
    
    enum ActionType: String {
        case view
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
