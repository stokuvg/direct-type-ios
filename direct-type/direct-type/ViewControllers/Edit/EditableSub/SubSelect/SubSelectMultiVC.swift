//
//  SubSelectMultiVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/22.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

class SubSelectMultiVC: SubSelectBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        singleMode = false //複数選択モード
        vwFoot.isHidden = false
        lcMainFootSpace.constant = lcFootHeight.constant
    }
    
    override var cellHeight: CGFloat {
        return 50
    }
}
