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
    var birthday: Date = Date(timeIntervalSince1970: 0)
    //case .hopeAreaA9:           return "希望勤務地"
    var hopeArea: [Code] = []
    //case .schoolA10:            return "最終学歴"
    var school: Code = ""
    //case .employmentStatusA21:  return "就業状況"
    var employmentStatus: Code = ""
    //case .jobExperimentsA11:        return "直近経験職種"
    //case .jobExperimentsYearA12:    return "直近の職種の経験年数"
    var lastJobExperiment: MdlResumeLastJobExperiment
    //case .salaryA13:            return "現在の年収"
    var salary: Code = ""
    //case .jobExperimentsA14:    return "追加経験職種"
    var jobExperiments: [MdlResumeJobExperiments]

    
    init(nickname: String, gender: Code, birthday: Date, hopeArea: [Code], school: Code, employmentStatus: Code, lastJobExperiment: MdlResumeLastJobExperiment, salary: Code, jobExperiments: [MdlResumeJobExperiments]) {
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
