//
//  MdlResumeJobExperiments.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlResumeJobExperiments: Codable {
    /** その他の経験職種(n≦9)：小分類 */
    public var jobType: Code
    /** その他の経験年数(n≦9) */
    public var jobExperimentYear: Code

    public init(jobType: Code, jobExperimentYear: Code) {
        self.jobType = jobType
        self.jobExperimentYear = jobExperimentYear
    }
    public enum CodingKeys: String, CodingKey {
        case jobType = "job_type"
        case jobExperimentYear = "job_experiment_year"
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
    case jobType
    case jobExperimentYear
    //表示名
    var dispName: String {
        switch self {
        case .jobType:              return "直近の経験職種：小分類"
        case .jobExperimentYear:    return "直近の経験年数"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String {
        return "MdlResumeJobExperiments_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}
