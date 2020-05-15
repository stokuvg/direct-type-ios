//
//  MdlResumeLastJobExperiment.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlResumeLastJobExperiment: Codable {

    /** 直近の経験職種：小分類 */
    public var jobType: Code
    /** 直近の経験年数 */
    public var jobExperimentYear: Code

    public init(jobType: Code, jobExperimentYear: Code) {
        self.jobType = jobType
        self.jobExperimentYear = jobExperimentYear
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ResumeLastJobExperiment) {
        let _jobType = "\(dto.jobType)"
        let _jobExperimentYear = "\(dto.jobExperimentYear)"
        self.init(jobType: _jobType, jobExperimentYear: _jobExperimentYear)
    }
    var debugDisp: String {
        return "[jobType: \(jobType)] [jobExperimentYear: \(jobExperimentYear)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResumeLastJobExperiment: String, EditItemProtocol {
    case jobType
    case jobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobType:              return "直近の経験職種"
        case .jobExperimentYear:    return "直近の経験年数"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
