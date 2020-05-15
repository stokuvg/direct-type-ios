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
    var languageToeicScore: String
    /** TOEFL（未記入：\&quot;\&quot;） */
    var languageToeflScore: String
    /** 英語スキル（未記入：\&quot;\&quot;） */
    var languageEnglish: String
    /** 英語以外語学スキル（未記入：\&quot;\&quot;） */
    var languageStudySkill: String

    init(languageToeicScore: String, languageToeflScore: String, languageEnglish: String, languageStudySkill: String) {
        self.languageToeicScore = languageToeicScore
        self.languageToeflScore = languageToeflScore
        self.languageEnglish = languageEnglish
        self.languageStudySkill = languageStudySkill
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeSkillLanguage) {
        let bufLanguageToeicScore: String = dto.languageToeicScore ?? ""
        let bufLanguageToeflScore: String = dto.languageToeflScore ?? ""
        self.init(languageToeicScore: bufLanguageToeicScore, languageToeflScore: bufLanguageToeflScore, languageEnglish: dto.languageEnglish, languageStudySkill: dto.languageStudySkill)
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
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
