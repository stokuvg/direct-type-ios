//
//  Validate+Resume.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension EditItemMdlResume {
    var valid: ValidInfo {
        switch self {
        case .employmentStatus:     return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .changeCount:          return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .lastJobExperiment:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperiments:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .businessTypes:        return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .school:               return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .skillLanguage:        return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .qualifications:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .ownPr:                return ValidInfo(required: false, keta: nil, max: nil, type: .undefine)
        }
    }
}
extension EditItemMdlResumeSchool {
    var valid: ValidInfo {
        switch self {
        case .schoolName:       return ValidInfo(required: true, keta: nil, max: nil, type: .zenkaku)
        case .faculty:       return ValidInfo(required: true, keta: nil, max: nil, type: .zenkaku)
        case .department:          return ValidInfo(required: false, keta: nil, max: nil, type: .zenkaku)
        case .graduationYear:   return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}

extension EditItemMdlResumeSkillLanguage {
    var valid: ValidInfo {
        switch self {
        case .languageToeicScore:   return ValidInfo(required: false, keta: nil, max: 3, type: .number)
        case .languageToeflScore:   return ValidInfo(required: false, keta: nil, max: 3, type: .number)
        case .languageEnglish:      return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .languageStudySkill:   return ValidInfo(required: false, keta: nil, max: nil, type: .undefine)
        }
    }
}
extension EditItemMdlResumeLastJobExperiment {
    var valid: ValidInfo {
        switch self {
        case .jobTypeAndJobExperimentYear:
            return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}
extension EditItemMdlResumeJobExperiments {
    var valid: ValidInfo {
        switch self {
        case .jobTypeAndJobExperimentYear:  return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        }
    }
}
