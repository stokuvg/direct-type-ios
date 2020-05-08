//
//  TmpBasicVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// NavigationBar あり
// TabBarController 無し
class TmpBasicVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor.init(colorType: .color_base)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
