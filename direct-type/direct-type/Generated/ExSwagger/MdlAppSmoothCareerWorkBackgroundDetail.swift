//
//  MdlAppSmoothCareerWorkBackgroundDetail.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

/** 職務経歴詳細 */
class MdlAppSmoothCareerWorkBackgroundDetail: Codable {

    /** 在籍企業の業種 */
    var businessType: Code
    var experienceManagement: Code
    /** PCスキル：Excel */
    var skillExcel: Code
    /** PCスキル：Word */
    var skillWord: Code
    /** PCスキル：PowerPoint */
    var skillPowerPoint: Code

    init(businessType: Code, experienceManagement: Code, skillExcel: Code, skillWord: Code, skillPowerPoint: Code) {
        self.businessType = businessType
        self.experienceManagement = experienceManagement
        self.skillExcel = skillExcel
        self.skillWord = skillWord
        self.skillPowerPoint = skillPowerPoint
    }
    //ApiモデルをAppモデルに変換して保持させる
    //＊これはアプリ専用モデルを想定しているため不要
    
    var debugDisp: String {
        return "[businessType: \(businessType)] [experienceManagement: \(experienceManagement)] [skillExcel: \(skillExcel)] [skillWord: \(skillWord)] [skillPowerPoint: \(skillPowerPoint)] "
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlAppSmoothCareerWorkBackgroundDetail: String, EditItemProtocol {
    case businessType
    case experienceManagement
    case skillExcel
    case skillWord
    case skillPowerPoint
    //表示名
    var dispName: String {
        switch self {
        case .businessType:         return "在籍企業の業種"
        case .experienceManagement: return "マネジメント経験"
        case .skillExcel:           return "PCスキル：Excel"
        case .skillWord:            return "PCスキル：Word"
        case .skillPowerPoint:      return "PCスキル：PowerPoint"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .businessType: return .businessType
        case .experienceManagement: return .management
        case .skillExcel: return .pcSkillExcel
        case .skillWord: return .pcSkillWord
        case .skillPowerPoint: return .pcSkillPowerPoint
        }
    }
    var dispUnit: String { //入力項目の単位表示
        switch self {
        default: return ""
        }
    }
    //Placeholder Text
    var placeholder: String {
        return ""//return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}

