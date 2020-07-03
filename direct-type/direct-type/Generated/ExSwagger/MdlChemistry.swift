//
//  MdlChemistry.swift
//  direct-type
//
//  Created by yamataku on 2020/07/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import SwaggerClient
import TudApi

class MdlChemistry: Codable {
    /** 相性診断のTOP3 */
    var chemistryTypeIds: [String]

    init(chemistryTypeIds: [String] = []) {
        self.chemistryTypeIds = chemistryTypeIds
    }
    
    convenience init(dto: GetChemistryResponseDTO) {
        self.init(chemistryTypeIds: dto.chemistryTypeIds)
    }
}
