//
//  DeepLinkHierarchy.swift
//  direct-type
//
//  Created by yamataku on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

struct DeepLinkHierarchy {
    enum TabType: String {
        case home
        case keep
        case entry
        case myPage
        case none
    }
    
    var tabType: TabType
    
    init(host tabText: String) {
        tabType = TabType(rawValue: tabText) ?? .none
    }
}
