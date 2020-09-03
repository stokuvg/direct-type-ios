//
//  MdlFirstInput.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MdlFirstInput: Codable {
    ////[A系統]初回入力
    //case .nicknameA6:           return "ニックネーム"
    var nickname: String = ""
    //case .genderA7:             return "性別"
    var gender: Code = ""
    //case .birthdayA8:           return "生年月日"
    var birthday: Date = Constants.SelectItemsUndefineDate
    //case .hopeAreaA9:           return "希望勤務地"
    var hopeArea: [Code] = []
    //case .schoolA10:            return "最終学歴"
    var school: Code = ""
    //case .employmentStatusA21:  return "就業状況"
    var employmentStatus: Code = ""
    //case .jobExperimentsA11:        return "直近経験職種"
    //case .jobExperimentsYearA12:    return "直近の職種の経験年数"
    var lastJobExperiment: MdlJobExperiment
    //case .salaryA13:            return "現在の年収"
    var salary: Code = ""
    //case .jobExperimentsA14:    return "追加経験職種"
    var jobExperiments: [MdlJobExperiment]

    
    init(nickname: String, gender: Code, birthday: Date, hopeArea: [Code], school: Code, employmentStatus: Code, lastJobExperiment: MdlJobExperiment, salary: Code, jobExperiments: [MdlJobExperiment]) {
        self.nickname = nickname
        self.gender = gender
        self.birthday = birthday
        self.hopeArea = hopeArea
        self.school = school
        self.employmentStatus = employmentStatus
        self.lastJobExperiment = lastJobExperiment
        self.salary = salary
        self.jobExperiments = jobExperiments
    }
        
//    //ApiモデルをAppモデルに変換して保持させる
//    convenience init(dto: GetCareerResponseDTO) {
//        print(#line, #function, dto)
//        var _businessTypes: [MdlCareerCard] = []
//        if let items = dto.careerHistory {
//            for item in items {
//                print(item.companyName, item.endWorkPeriod)
//                _businessTypes.append(MdlCareerCard(dto: item))
//            }
//        }
//        self.init(businessTypes: _businessTypes)
//    }
    //=== 作成・更新のモデルは、アプリ=>APIなので不要だな ===

    var debugDisp: String {
        return "[nickname: \(nickname)]"
    }
}
//=== 編集用の項目と定義など
enum EditItemMdlFirstInput: String, EditItemProtocol {
    case nickname
    case gender
    case birthday
    case hopeArea
    case school
    case employmentStatus
    case lastJobExperiment
    case salary
    case jobExperiments
    //表示名
    var dispName: String {
        switch self {
        case .nickname:             return "ニックネーム"
        case .gender:               return "性別"
        case .birthday:             return "生年月日"
        case .hopeArea:             return "希望勤務地"
        case .school:               return "最終学歴"
        case .employmentStatus:     return "就業状況"
        case .lastJobExperiment:    return "直近経験職種"
        case .salary:               return "現在の年収"
        case .jobExperiments:       return "追加の経験職種"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .employmentStatus: return .employmentStatus
        case .gender: return .gender
        case .hopeArea: return .entryPlace
        case .school: return .schoolType
        case .salary: return .salarySelect//コードではなく選択数値が入るもの
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
        switch self {
        case .gender:
            return "選択してください"
        case .hopeArea:
            return "複数選択可"
        default:
            return ""//return "[\(self.itemKey) PlaceHolder]"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
//=== 編集用の項目と定義など
enum EditItemMdlFirstInputLastJobExperiments: String, EditItemProtocol {
    case jobTypeAndJobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobTypeAndJobExperimentYear: return "直近の経験職種"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .jobTypeAndJobExperimentYear: return .jobType
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
//=== 編集用の項目と定義など
enum EditItemMdlFirstInputJobExperiments: String, EditItemProtocol {
    case jobTypeAndJobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobTypeAndJobExperimentYear: return "追加の経験職種"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .jobTypeAndJobExperimentYear: return .jobType
        }
    }
    var dispUnit: String { //入力項目の単位表示
        switch self {
        default: return ""
        }
    }
    //Placeholder Text
    var placeholder: String {
        switch self {
        case .jobTypeAndJobExperimentYear:
            return "複数選択可"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
