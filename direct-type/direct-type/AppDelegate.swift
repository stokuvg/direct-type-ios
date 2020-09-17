//
//  AppDelegate.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient
import AppsFlyerLib
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let _launchOptions = launchOptions ?? [:]
        LogManager.appendLogEx(.ALWAYS, "起動", String(repeating: "=", count: 44), _launchOptions.debugDescription, #function, #line)
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().isTranslucent = false

        if AppDefine.isDebugForAWS {
            AWSDDLog.sharedInstance.logLevel = .verbose // TODO: Disable or reduce log level in production
            AWSDDLog.add(AWSDDTTYLogger.sharedInstance) // TTY = Log everything to Xcode console
        }

        //=== Cognito認証の初期化処理を組み込む
        // Amazon Cognito 認証情報プロバイダーを初期化します
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType:.APNortheast1,
            identityPoolId: AppDefine.CognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(
            region:.APNortheast1,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
                if userState != .signedIn {
                    AWSMobileClient.default().clearKeychain()
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }

        setupAppsFlyer()
        tryPostActivity()//これはCognito初期化後でないと意味ないのでは？
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        firstLaunhVC(openUrl: nil)//アプリ起動時の処理が完了してから、画面遷移させるため
        window?.makeKeyAndVisible()
        return true
    }
    
    private func firstLaunhVC(openUrl: URL? = nil) {
        let sb = UIStoryboard(name: "LaunchVC", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Sbid_LaunchVC") as! LaunchVC
        vc.deepLinkUrl = openUrl
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchViewController(vc) //遷移アニメ付きで表示（ただこのタイミングだと遷移元がないから無効か）
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        firstLaunhVC(openUrl: url)//アプリ起動時の処理が完了してから、画面遷移させるため
        return true
    }
    //遷移アニメーション付きで表示する
    func switchViewController(_ viewController: UIViewController, _ options: UIView.AnimationOptions =  .transitionCrossDissolve) {
        UIView.transition(with: self.window!, duration: 0.6, options: options, animations: {
            let oldState: Bool = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }
}

private extension AppDelegate {
    // ログイン済みだった場合は最終ログイン情報を送る
    func tryPostActivity() {
        if AuthManager.shared.isLogin {
            ApiManager.createActivity()
        }
    }
    
}

extension AppDelegate: AppsFlyerTrackerDelegate {
    @objc func sendLaunch(app: Any) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        // Handle Conversion Data (Deferred Deep Link)
    }
    
    func onConversionDataFail(_ error: Error) {
        // Erroe for handle Conversion Data (Deferred Deep Link)
    }
    
    func setupAppsFlyer() {
        AppsFlyerTracker.shared().appsFlyerDevKey = AppDefine.AppsFlyerTracker_appsFlyerDevKey
        AppsFlyerTracker.shared().appleAppID = AppDefine.AppsFlyerTracker_appleAppID
        AppsFlyerTracker.shared().delegate = self
        #if DEBUG
            AppsFlyerTracker.shared().isDebug = true
        #endif
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(sendLaunch),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
}
