//
//  BusinessAvilityScore.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

struct BusinessAvilityScore {
    let quickAction: Double
    let toughness: Double
    let spiritOfChallenge: Double
    let logical: Double
    let leadership: Double
    let dedicationAndSupport: Double
    let cooperativeness: Double
    let initiative: Double
    let creativityAndIdea: Double
    let responsibilityAndSteadiness: Double
}

enum BusinessAvilityType: String, CaseIterable {
    case quickAction = "迅速な行動力"
    case toughness = "粘り強さ"
    case spiritOfChallenge = "チャレンジ精神"
    case logical = "論理性"
    case leadership = "リーダーシップ"
    case dedicationAndSupport = "献身性・サポート力"
    case cooperativeness = "協調性"
    case initiative = "主体性"
    case creativityAndIdea = "創造性・アイデア力"
    case responsibilityAndSteadiness = "責任感・着実性"
    
    var nameLineBlakable: String {
        switch self {
        case .quickAction:
            return "迅速な行動力"
        case .toughness:
            return "粘り強さ"
        case .spiritOfChallenge:
            return "チャレンジ精神"
        case .logical:
            return "論理性"
        case .leadership:
            return "リーダーシップ"
        case .dedicationAndSupport:
            return "献身性・\nサポート力"
        case .cooperativeness:
            return "協調性"
        case .initiative:
            return "主体性"
        case .creativityAndIdea:
            return "創造性・\nアイデア力"
        case .responsibilityAndSteadiness:
            return "責任感・\n着実性"
        }
    }
}
