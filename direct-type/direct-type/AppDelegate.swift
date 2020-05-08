//
//  AppDelegate.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().isTranslucent = false
        
        // ログイン済み情報があればタブ表示,無ければ初期値入力,ログイン画面へ
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        
        self.window?.rootViewController = tabBC
        
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

