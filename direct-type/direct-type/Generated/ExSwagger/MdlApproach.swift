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
    
    init(isScoutEnable: Bool) {
        self.isScoutEnable = isScoutEnable
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: GetSettingsResponseDTO) {
        self.init(isScoutEnable: dto.scoutEnable)
    }

    var debugDisp: String {
        return "[isScoutEnable: \(isScoutEnable)]"
    }
}
