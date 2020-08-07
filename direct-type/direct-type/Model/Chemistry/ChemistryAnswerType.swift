//
//  ChemistryAnswerType.swift
//  direct-type
//
//  Created by yamataku on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

enum ChemistryAnswerType {
    case no
    case ifAnythingsNo
    case ifAnythingsYes
    case yes
    case unanswered
    
    var score: Int? {
        switch self {
        case .no:
            return 0
        case .ifAnythingsNo:
            return 1
        case .ifAnythingsYes:
            return 2
        case .yes:
            return 3
        case .unanswered:
            return nil
        }
    }
}
