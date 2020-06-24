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
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }

        window = UIWindow(frame: UIScreen.main.bounds)

        if AuthManager.shared.isLogin {
            let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
            let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")

            window?.rootViewController = tabBC
        } else {
            let inputSB = UIStoryboard(name: "InitialInputStartVC", bundle: nil)
            let startNavi = inputSB.instantiateViewController(withIdentifier: "Sbid_InitialInputNavi") as! UINavigationController

            window?.rootViewController = startNavi
        }

        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 想定されるURL形式: direct-type://myPage/vacanciesDetail?vacanciesId=123&keepId=456&searchText=hoge&campainText=fuga
        let deepLinkHierarchy = DeepLinkHierarchy(host: url.host ?? "", path: url.path , query: url.query ?? "")
        guard let rootTabBarController = window?.rootViewController as? UITabBarController else { return true }
        guard let tabIndex = deepLinkHierarchy.tabType.index else { return true }
        rootTabBarController.selectedIndex = tabIndex
        return true
    }
}

private extension AppDelegate {
    // 初期入力画面を表示
    func displayInitialInputVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialSB = UIStoryboard(name: "InitialInputRegistVC", bundle: nil)
        let initialVC = initialSB.instantiateViewController(withIdentifier: "InitialInputRegistVC") as! InitialInputRegistVC
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
}
