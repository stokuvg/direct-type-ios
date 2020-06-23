//
//  AppDelegate.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient

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
        
        var loginFlag:Bool = false

        //=== Cognito認証の初期化処理を組み込む
        // Amazon Cognito 認証情報プロバイダーを初期化します
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType:.APNortheast1,
            identityPoolId: Constants.CognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(
            region:.APNortheast1,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
//                // FIXME: デバッグのために強制的に初期登録動線を表示
//                loginFlag = true
            } else if let error = error {
                print("error: \(error.localizedDescription)")
//                loginFlag = false
            }
        }

        // ログイン済み情報があればタブ表示,無ければ初期値入力,ログイン画面へ
        if AWSMobileClient.default().currentUserState == .signedIn {
            // FIXME: このPR提出時に元に戻す
            loginFlag = false
        } else {
            loginFlag = false
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if loginFlag {
            let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
            let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
            
            self.window?.rootViewController = tabBC
        } else {
            let inputSB = UIStoryboard(name: "InitialInput", bundle: nil)
            let startNavi = inputSB.instantiateViewController(withIdentifier: "Sbid_InitialInputNavi") as! UINavigationController
            
            self.window?.rootViewController = startNavi
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // 初期入力画面を表示
    func displayInitialInputVC() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let initialSB = UIStoryboard(name: "InitialInput", bundle: nil)
        
        let initialVC = initialSB.instantiateViewController(withIdentifier: "Sbid_InitialInputListVC") as! InitialInputListVC
        
        self.window?.rootViewController = initialVC
        
        self.window?.makeKeyAndVisible()
        
    }
}
