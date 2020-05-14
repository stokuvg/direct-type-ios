//
//  MdlCareer.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

/** 職務経歴書 */
class MdlCareer: Codable {
     var businessTypes: [MdlCareerCard]

    init(businessTypes: [MdlCareerCard] = []) {
        self.businessTypes = businessTypes
    }
    enum CodingKeys: String, CodingKey {
        case businessTypes = "business_types"
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: Career) {
        var _businessTypes: [MdlCareerCard] = []
        if let items = dto.businessTypes {
            for item in items {
                _businessTypes.append(MdlCareerCard(dto: item))
            }
        }
        self.init(businessTypes: _businessTypes)
    }
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
        case .businessTypes:       return "氏"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String {
        return "Career_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}

