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
        //追加だった場合に個数が一位上ならBadgeがつく（現状だと失敗時にもBadgeがついてしまう）
        let cntKeep: Int = KeepManager.shared.getKeepCount()
        if let tabItems: [UITabBarItem] = self.tabBarController?.tabBar.items {
            let tabItem:UITabBarItem = tabItems[Constants.TabIndexKeepList] //キープリストのタブ位置
            tabItem.badgeColor = .clear
            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .normal)
            if cntKeep > 0 {
                if let keepMode: String = notification.userInfo?[Constants.NotificationKeepStatusChangedParamMode] as? String {
                    let isKeepAdded = keepMode == Constants.NotificationKeepStatusChangedParamMode_Add
                    if isKeepAdded {
                        tabItem.badgeValue = "●"//1件以上あり、キープ追加だった場合にはBadge表示する
                    } else {
                        //1件以上あっても、キープ削除の結果だったらBadge状態は変えずに現状維持とする（2件を1件に減らした場合など）
                    }
                }
            } else {
                tabItem.badgeValue = nil //0件だったらBadge除去
            }
        }
    }
}
