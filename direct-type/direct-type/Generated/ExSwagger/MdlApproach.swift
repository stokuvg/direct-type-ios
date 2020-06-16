//
//  MdlApproach.swift
//  direct-type
//
//  Created by yamataku on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import TudApi

/** アプローチ設定 */
class MdlApproach: Codable {
    /** スカウト可否フラグ */
    var isScoutEnable: Bool
    /** レコメンド可否フラグ */
    var isRecommendationEnable: Bool
    
    init(isScoutEnable: Bool, isRecommendationEnable: Bool) {
        self.isScoutEnable = isScoutEnable
        self.isRecommendationEnable = isRecommendationEnable
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: GetApproachResponseDTO) {
        self.init(isScoutEnable: dto.isScoutEnable, isRecommendationEnable: dto.isRecommendationEnable)
    }

    var debugDisp: String {
        return "[isScoutEnable: \(isScoutEnable)] [isRecommendationEnable: \(isRecommendationEnable)]"
    }
}
