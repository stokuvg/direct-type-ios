//
//  SubEditVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SubEditBaseVC: EditableTableBasicVC {
    override func initData(_ item: MdlItemH) {
        self.item = item
        //=== IndexPathなどを設定するため
        editableModel.initItemEditable(item.childItems)
    }
}
