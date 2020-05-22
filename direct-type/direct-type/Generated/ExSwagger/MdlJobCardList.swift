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
    var jobCards: [MdlJobCard]
    
    init(jobCards: [MdlJobCard] = []) {
        self.jobCards = jobCards
    }
    
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: JobCardList) {
        var _jobCards: [MdlJobCard] = []
        if let items = dto.jobCards {
            for item in items {
                _jobCards.append(MdlJobCard(dto: item))
            }
        }
        self.init(jobCards: _jobCards)
    }
    
    var debugDisp: String {
        return "[jobDatas: \(jobCards.count)件]"
    }
}
