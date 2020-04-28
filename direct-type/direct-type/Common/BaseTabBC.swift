//
//  BaseTabBC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class BaseTabBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.init(colorType: .color_sub)
        
        self.selectedIndex = 0
        
        /// 赤ポチ
        // 求人        つかない
        // キープ       つく
        // おすすめ     つく  TODO:MVPではタブごと無い
        // 応募管理     つかない
        // マイページ    付かない
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor(named: "color-base")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
