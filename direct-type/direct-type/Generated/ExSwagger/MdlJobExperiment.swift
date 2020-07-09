//
//  MdlResumeJobExperiments.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlJobExperiment: Codable {
    /** 直近の経験職種：小分類 *//** その他の経験職種(n≦9)：小分類 */
    public var jobType: Code
    /** 直近の経験年数 *//** その他の経験年数(n≦9) */
    public var jobExperimentYear: Code

    public init(jobType: Code, jobExperimentYear: Code) {
        self.jobType = jobType
        self.jobExperimentYear = jobExperimentYear
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeJobExperiments) {
        let _jobType = "\(dto.jobType ?? 0)"
        let _jobExperimentYear = "\(dto.jobExperimentYear ?? 0)"
        self.init(jobType: _jobType, jobExperimentYear: _jobExperimentYear)
    }
    var debugDisp: String {
        return "[jobType: \(jobType)] [jobExperimentYear: \(jobExperimentYear)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeJobExperiments: String, EditItemProtocol {
    case jobTypeAndJobExperimentYear
//    case jobType
//    case jobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobTypeAndJobExperimentYear: return "経験職種＆年数"
//        case .jobType:              return "経験職種"
//        case .jobExperimentYear:    return "経験年数"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .jobTypeAndJobExperimentYear: return .jobType
//        case .jobType: return .jobType
//        case .jobExperimentYear: return .jobExperimentYear
        }
    }
    //Placeholder Text
    var placeholder: String {
        switch self {
        case .jobTypeAndJobExperimentYear:
            return "複数選択可能"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeLastJobExperiment: String, EditItemProtocol {
    case jobTypeAndJobExperimentYear
//    case jobType
//    case jobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobTypeAndJobExperimentYear: return "直近の経験職種＆年数"
//        case .jobType:              return "直近の経験職種"
//        case .jobExperimentYear:    return "直近の経験年数"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .jobTypeAndJobExperimentYear: return .jobType
//        case .jobType: return .jobType
//        case .jobExperimentYear: return .jobExperimentYear
        }
    }
    //Placeholder Text
    var placeholder: String {
        return ""//return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
