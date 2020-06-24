//
//  DeepLinkHierarchy.swift
//  direct-type
//
//  Created by yamataku on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

struct DeepLinkHierarchy {
    enum TabType: String, CaseIterable {
        case home
        case keep
        case entry
        case myPage
        case none
    }
    
    enum ScreenNameType: String {
        // TODO: 必要な画面に応じてcaseを追加する
        // FIXME: それっぽいcaseを参考として定義しているが、不要になった際に削除する
        case vacanciesDetail // ※サンプルプロパティ
        case chemistry // ※サンプルプロパティ
        case changeAccount // ※サンプルプロパティ
        case none // ※サンプルプロパティ
    }
    
    var tabType: TabType
    var screenNameType: ScreenNameType
    var query: DeepLinkQuery
    
    init(host tabText: String, path: String, query queryText: String) {
        tabType = TabType(rawValue: tabText) ?? .none
        screenNameType = ScreenNameType(rawValue: path) ?? .none
        query = DeepLinkQuery(queryText)
    }
}

struct DeepLinkQuery {
    // TODO: 必要なパラメータのキーをプロパティとして追加していく
    // FIXME: それっぽいプロパティを参考として定義しているが、不要になった際に削除する
    var vacanciesId: Int? // ※サンプルプロパティ
    var keepId: Int? // ※サンプルプロパティ
    var searchText: String? // ※サンプルプロパティ
    var campainText: String? // ※サンプルプロパティ
    
    init(_ query: String) {
        if let vacanciesIdext = query.getValue(by: "vacanciesId") {
            vacanciesId = Int(vacanciesIdext)
        }
        if let keepIdText = query.getValue(by: "keepId") {
            keepId = Int(keepIdText)
        }
        searchText = query.getValue(by: "searchText")
        campainText = query.getValue(by: "campainText")
    }
}

private extension String {
    func getValue(by key: String) -> String? {
        return components(separatedBy: "&")
            .map({ $0.components(separatedBy: "=") })
            .first(where: { $0.first == key })?[1]
    }
}
