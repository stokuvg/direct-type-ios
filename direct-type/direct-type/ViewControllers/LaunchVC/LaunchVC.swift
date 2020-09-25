//
//  LaunchVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD

//=== アプリ起動直後の自前Lauch画面
// 下記の順番で、アプリ起動時に必須な初期処理を実施していく
// 0) dispVersion()     現在のアプリバージョン情報を表示すr
// 1) chkNeedUpdate()   強制アップデートが必要か確認し、誘導する
// 2) firstFetchAll()   必要なフェッチを実施し、完了したら初期画面へ遷移する
// 3) switchNextVC()    初期画面への遷移

class LaunchVC: BaseVC {
    @IBOutlet weak var lblVerStatus: UILabel!
    var deepLinkUrl: URL? = nil //openURLで開かれた場合の情報引継ぎ用

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispVersion()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chkNeedUpdate {
            self.firstFetchAll()//継続処理を記載
        }//アップデートチェック
    }
    private func firstFetchAll() {
        print("❤️❤️継続処理を実施❤️❤️")
        //FIXME: 今は初期フェッチ不要にしているので
        //self.fetchGetProfile()//とりあえず、プロフィール取得させてみる
        self.switchNextVC() //次の画面へ遷移する
    }
    private func switchNextVC() {
        sleep(1) // スプラッシュの表示を確実にするための起動遅延
        self.switchRootVC() //状況に応じて、画面を振り分ける
        //さらに、deepLink遷移させる（情報がある場合）
        if let url = self.deepLinkUrl {
            let deepLinkHierarchy = DeepLinkHierarchy(host: url.host ?? "", path: url.path, query: url.query ?? "")
            self.transitionToDeepLinkDestination(with: deepLinkHierarchy)
            self.deepLinkUrl = nil //念のため、情報をクリアしておく
        }
    }
}

//=== バージョン表示
extension LaunchVC {
    func dispVersion() {
        var disp: String = ""
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        disp = "Version: \(version)"
        #if DEBUG
            if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                if version != build {
                    disp = "Version: \(version) (\(build))"
                }
            }
        #endif
        let attrDisp = TudTool.attrText(text: disp, fontType: .font_SS, textColor: UIColor(colorType: .color_light_gray)!, alignment: .left)
        lblVerStatus.attributedText = attrDisp
    }
}

// 1) chkNeedUpdate()   強制アップデートが必要か確認し、誘導する
//　⇒【UIViewController+UpdateCheck.swift】にて処理

// 2) firstFetchAll()   必要なフェッチを実施し、完了したら初期画面へ遷移する
extension LaunchVC {
    private func fetchGetProfile() {
        SVProgressHUD.show()
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
        }
        .catch { (error) in
        }
        .finally {
            SVProgressHUD.dismiss()
            self.switchNextVC() //次の画面へ遷移する
        }
    }
    private func transitionToDeepLinkDestination(with hierarchy: DeepLinkHierarchy) {
        guard let rootNavigationController = hierarchy.rootNavigation,
            let destinationViewController = hierarchy.distination else { return }
        rootNavigationController.popToRootViewController(animated: false)
        rootNavigationController.pushViewController(destinationViewController, animated: true)
    }
}
// 3) switchNextVC()    初期画面への遷移
extension LaunchVC {
    private func switchRootVC() {
        if AuthManager.shared.isLogin {
            let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
            let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchViewController(tabBC) //遷移アニメ付きで表示（ただこのタイミングだと遷移元がないから無効か）
        } else {
            let inputSB = UIStoryboard(name: "InitialInputStartVC", bundle: nil)
            let startNavi = inputSB.instantiateViewController(withIdentifier: "Sbid_InitialInputNavi") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchViewController(startNavi) //遷移アニメ付きで表示（ただこのタイミングだと遷移元がないから無効か）
        }
    }
}
