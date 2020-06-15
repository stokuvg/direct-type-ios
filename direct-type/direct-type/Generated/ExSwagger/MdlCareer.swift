//
//  MdlCareer.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi

/** 職務経歴書 */
class MdlCareer: Codable {
     var businessTypes: [MdlCareerCard]

    init(businessTypes: [MdlCareerCard] = []) {
        self.businessTypes = businessTypes
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: GetCareerResponseDTO) {
        var _businessTypes: [MdlCareerCard] = []
        if let items = dto.careerHistory {
            for item in items {
                _businessTypes.append(MdlCareerCard(dto: item))
            }
        }
        self.init(businessTypes: _businessTypes)
    }
    //=== 作成・更新のモデルは、アプリ=>APIなので不要だな ===

    var debugDisp: String {
        return "[businessTypes: \(businessTypes.count)件]"
    }
}

//=== 編集用の項目と定義など
enum EditItemCareer: String, EditItemProtocol {
    case businessTypes
    //表示名
    var dispName: String {
        switch self {
        case .businessTypes:    return "職務経歴書"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .businessTypes: return .businessType
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}

