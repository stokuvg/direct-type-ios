//
//  MdlJob.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi

// ホーム 求人
class MdlJobCardList: Codable {
    var nextPage: Bool
    var updateAt: String
    var jobCards: [MdlJobCard]
    
    init(updateAt:String = "", hasNext:Bool = false, jobList:[MdlJobCard] = []) {
        self.updateAt = updateAt
        self.nextPage = hasNext
        self.jobCards = jobList
    }
    
    convenience init(dto: GetJobsResponseDTO) {
        let updateAt = dto.recommendedAt
        let hasNext = dto.hasNext
//        let jobs = dto.jobs
        var lists:[MdlJobCard] = []
        for i in 0..<dto.jobs.count {
            let _job = dto.jobs[i]
            lists.append(MdlJobCard(dto: _job))
        }
        
        self.init(updateAt: updateAt, hasNext:hasNext, jobList:lists)
    }
    
    //ApiモデルをAppモデルに変換して保持させる
    /*
    convenience init(dto: MdlJobCardList) {
        let updateAt = dto.updateAt
        var _jobCards: [MdlJobCard] = []
        if let items = dto.jobCards {
            for item in items {
                _jobCards.append(MdlJobCard(dto: item))
            }
        }
        self.init(updateAt:updateAt!, jobCards: _jobCards)
    }
    */
    
    var debugDisp: String {
        return "[jobDatas: \(jobCards.count)件]"
    }
}
