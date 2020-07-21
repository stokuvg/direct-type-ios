//
//  BaseTabBC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class BaseTabBC: UITabBarController {
    
    private var profile: MdlProfile?
    private var resume: MdlResume?
    private var shouldTransitionToInitialInput: Bool {
        return profile == nil || resume == nil
    }

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
        initialConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor(named: "color-base")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

private extension BaseTabBC {
    func initialConfigure() {
        if shouldTransitionToInitialInput {
            fetchProfile()
        }
    }
    
    // プロフィールデータ取得
    func fetchProfile() {
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            self.profile = result
            UserDefaultsManager.shared.setObject(Date(), key: .profileFetchDate)
        }
        .catch { _ in }
        .finally {
            self.fetchResume()//次の処理の呼び出し
        }
    }
    // 履歴書データ取得
    func fetchResume() {
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            self.resume = result
        }
        .catch { _ in}
        .finally {
            if self.shouldTransitionToInitialInput {
                self.showConfirm()
            }
        }
    }
    
    func showConfirm() {
        let alert = UIAlertController(title: "初期入力をしてください", message: "", preferredStyle:  .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in self.transitionToInitialInput() })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func transitionToInitialInput() {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Sbid_FirstInputPreviewVC") as! FirstInputPreviewVC
        vc.hidesBottomBarWhenPushed = true
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
    }
}
