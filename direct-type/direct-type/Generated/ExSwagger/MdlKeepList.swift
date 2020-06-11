//
//  MdlKeepList.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi

class MdlKeepList: Codable {

    /** true: 次ページあり, false: 次ページなし */
    var hasNext: Bool
    /** キープ求人一覧 */
    var keepJobs: [MdlKeepJob]

    init(hasNext: Bool = false, keepJobs: [MdlKeepJob] = []) {
        self.hasNext = hasNext
        self.keepJobs = keepJobs
    }
        
    convenience init(dto: GetKeepsResponseDTO) {
        let hasNext = dto.hasNext
//        let jobs = dto.jobs
        var lists:[MdlKeepJob] = []
        for i in 0..<dto.keepJobs.count {
            let keep = dto.keepJobs[i]
            lists.append(MdlKeepJob(dto: keep))
        }
        
        self.init(hasNext: hasNext, keepJobs: lists)
    }

    var debugDisp: String {
        return ""
    }
        
}
