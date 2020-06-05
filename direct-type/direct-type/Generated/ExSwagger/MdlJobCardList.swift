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
    var jobCards: [Job]
    
    init(updateAt:String, hasNext:Bool,jobs:[Job]) {
        self.updateAt = updateAt
        self.nextPage = hasNext
        self.jobCards = jobs
    }
    /*
    init(updateAt:String, hasNext:Bool, jobs:[Job]) {
        self.nextPage = hasNext
        self.updateAt = updateAt
        
        var _mdlJobCards:[MdlJobCard] = []
        for _job in jobs {
            let mdlJobCard = MdlJobCard.init(dto: _job)
            _mdlJobCards.append(mdlJobCard)
        }
        
        self.jobCards = _mdlJobCards
    }
    */
    
    convenience init(dto: GetJobsResponseDTO) {
        let updateAt = dto.recommendedAt
        let hasNext = dto.hasNext
        let jobs = dto.jobs
        
        self.init(updateAt: updateAt, hasNext:hasNext, jobs:jobs)
    }
    
    //ApiモデルをAppモデルに変換して保持させる
    /*
    convenience init(dto: JobCardList) {
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
