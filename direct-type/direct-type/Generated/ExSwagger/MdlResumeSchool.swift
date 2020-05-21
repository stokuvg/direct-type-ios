//
//  MdlResumeSchool.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlResumeSchool: Codable {

    /** 学校名 */
    var schoolName: String
    /** 学部 */
    var department: String
    /** 学科・専攻 */
    var subject: String
    /** 卒業年月 */
    var graduationYear: String

    init(schoolName: String, department: String, subject: String, graduationYear: String) {
        self.schoolName = schoolName
        self.department = department
        self.subject = subject
        self.graduationYear = graduationYear
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeSchool) {        
        self.init(schoolName: dto.schoolName, department: dto.department, subject: dto.subject, graduationYear: dto.guraduationYear)
    }
    
    var debugDisp: String {
        return "[schoolName: \(schoolName)] [department: \(department)] [subject: \(subject)] [graduationYear: \(graduationYear)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeSchool: String, EditItemProtocol {
    case schoolName
    case department
    case subject
    case graduationYear
    //表示名
    var dispName: String {
        switch self {
        case .schoolName:       return "学校名"
        case .department:       return "学部"
        case .subject:          return "学科・専攻"
        case .graduationYear:   return "卒業年月"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        default: return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
