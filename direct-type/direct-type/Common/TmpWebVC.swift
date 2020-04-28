//
//  TmpWebVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// WebViewの表示
// 下部にBack/Forwardボタン
class TmpWebVC: BasePresentVC {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.tmpNavigationBar.tintColor = UIColor.init(colorType: .color_white)
        self.tmpNavigationBar.barTintColor = UIColor.init(colorType: .color_main)
        self.tmpNavigationBar.titleTextAttributes = [
            .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
            .foregroundColor: UIColor.init(colorType: .color_white) as Any,
        ]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor.init(colorType: .color_base)
        
        // 閉じるボタン
        self.leftCloseDisp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
