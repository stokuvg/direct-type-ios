//
//  MdlResumeSkillLanguage.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlResumeSkillLanguage: Codable {

    /** TOEIC（未記入：\&quot;\&quot;） */
    var languageToeicScore: String?
    /** TOEFL（未記入：\&quot;\&quot;） */
    var languageToeflScore: String?
    /** 英語スキル（未記入：\&quot;\&quot;） */
    var languageEnglish: String
    /** 英語以外語学スキル（未記入：\&quot;\&quot;） */
    var languageStudySkill: String

    init(languageToeicScore: String?, languageToeflScore: String?, languageEnglish: String, languageStudySkill: String) {
        self.languageToeicScore = languageToeicScore
        self.languageToeflScore = languageToeflScore
        self.languageEnglish = languageEnglish
        self.languageStudySkill = languageStudySkill
    }
    enum CodingKeys: String, CodingKey {
        case languageToeicScore = "language_toeic_score"
        case languageToeflScore = "language_toefl_score"
        case languageEnglish = "language_english"
        case languageStudySkill = "language_study_skill"
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeSkillLanguage) {
        self.init(languageToeicScore: dto.languageToeicScore, languageToeflScore: dto.languageToeflScore, languageEnglish: dto.languageEnglish, languageStudySkill: dto.languageStudySkill)
    }
    var debugDisp: String {
        return "[toeic: \(languageToeicScore)] [toefl: \(languageToeflScore)] [english: \(languageEnglish)] [study: \(languageStudySkill)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeSkillLanguage: String, EditItemProtocol {
    case languageToeicScore
    case languageToeflScore
    case languageEnglish
    case languageStudySkill

    //表示名
    var dispName: String {
        switch self {
        case .languageToeicScore:   return "TOEIC"
        case .languageToeflScore:   return "TOEFL"
        case .languageEnglish:      return "英語スキル"
        case .languageStudySkill:   return "英語以外語学スキル"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String {
        return "MdlResumeSkillLanguage_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}
