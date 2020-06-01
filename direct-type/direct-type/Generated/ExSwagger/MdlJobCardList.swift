//
//  MdlJob.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

// ホーム 求人
class MdlJobCardList: Codable {
    var nextPage: Int
    var updateAt: String
    var jobCards: [MdlJobCard]
    
    init(updateAt:String = "",jobCards: [MdlJobCard] = []) {
        self.nextPage = 1
        self.updateAt = ""
        self.jobCards = jobCards
    }
    
    //ApiモデルをAppモデルに変換して保持させる
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
    
    var debugDisp: String {
        return "[jobDatas: \(jobCards.count)件]"
    }
}
