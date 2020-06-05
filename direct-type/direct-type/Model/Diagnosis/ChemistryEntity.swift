//
//  DiagnosisResult.swift
//  direct-type
//
//  Created by yamataku on 2020/06/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

final class ChemistryEntity {
    enum PersonalityType: String, CaseIterable {
        case reformer = "改革する人"
        case helper = "人を助ける人"
        case toAchieve = "達成する人"
        case unique = "個性的な人"
        case toExamine = "調べる人"
        case faithful = "忠実な人"
        case enthusiastic = "熱中する人"
        case challenger = "挑戦する人"
        case peaceful = "平和をもたらす人"
        
        var imageName: String {
            switch self {
            case .reformer:
                return "illust01"
            case .helper:
                return "illust01"
            case .toAchieve:
                return "illust01"
            case .unique:
                return "illust01"
            case .toExamine:
                return "illust01"
            case .faithful:
                return "illust01"
            case .enthusiastic:
                return "illust01"
            case .challenger:
                return "illust01"
            case .peaceful:
                return "illust01"
            }
        }
    }
}
