//
//  BaseNaviController.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class BaseNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initNotify()
    }
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    func initNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keepListChanged(notification:)), name: Constants.NotificationKeepStatusChanged, object: nil)
    }
    @objc func keepListChanged(notification: NSNotification) {
        //タブの新着チェックは独立させてタブにまかせたい（各所で叩かれるKeep須佐が管理するのは破綻するので）
        //現在の通知はKeep更新だけど、追加と削除のどちらかも分かるようにした方が良さげ。追加変更だけBadgeつくので
        let cntKeep: Int = KeepManager.shared.getKeepCount()
        if let tabItems: [UITabBarItem] = self.tabBarController?.tabBar.items {
            let tabItem:UITabBarItem = tabItems[1] //キープリストのタブ位置
            tabItem.badgeColor = .clear
            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .normal)
            if cntKeep > 0 {
                tabItem.badgeValue = "●"
            } else {
                tabItem.badgeValue = nil
            }
        }
    }
}
