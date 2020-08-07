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
    var faculty: String
    /** 学科・専攻 */
    var department: String
    /** 卒業年月 */
    var graduationYear: String

    var isHaveRequired: Bool {
        return !schoolName.isEmpty && !faculty.isEmpty && !graduationYear.isEmpty
    }

    init(schoolName: String, faculty: String, department: String, graduationYear: String) {
        self.schoolName = schoolName
        self.faculty = faculty
        self.department = department
        self.graduationYear = graduationYear
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeSchool) {        
        self.init(schoolName: dto.schoolName, faculty: dto.department, department: dto.subject, graduationYear: dto.graduationYear)
    }
    
    var debugDisp: String {
        return "[schoolName: \(schoolName)] [department: \(faculty)] [subject: \(department)] [graduationYear: \(graduationYear)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeSchool: String, EditItemProtocol {
    case schoolName
    case faculty
    case department
    case graduationYear
    //表示名
    var dispName: String {
        switch self {
        case .schoolName:       return "学校名"
        case .faculty:          return "学部・学科"
        case .department:       return "専攻"
        case .graduationYear:   return "卒業年月"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        default: return .undefine
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
