//
//  LaunchVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD

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

    private func chkNeedUpdate() {
        //バージョンチェックなどするなら、ここで
        VersionCheckManager.getStoreVersion()
        .done { (storeVer) in
            let appVer = VersionCheckManager.getAppVersion()
            var updateTyep: VersionUpdateType = .none
            switch appVer.checkVersion(target: storeVer) {
            case .same: break //公開中のバージョンと同じなので、何もしない
            case .older(let type):
                switch type {
                case .major: updateTyep = .force
                case .minor: updateTyep = .optional
                case .patch: break //マイナーバージョンアップも誘導しない場合
                }
            case .newer(_): break //自分のバージョンの方が新しいので、何もしない
            }
            //===結果に応じて、画面遷移
            switch updateTyep {
            case .none:     self.firstFetchAll()//本来の処理を実施
            case .optional: self.dispUpdateDialog()//アップデート誘導表示
            case .force:    self.dispForceUpdateDialog()//強制アップデート表示
            }
        }
        .catch { (_) in
            //バージョン取得に失敗しても、アプリ利用可能にして良い場合
        }
        .finally {
        }
    }
    private func dispUpdateDialog() {
        self.showConfirm(title: "新しいバージョンがあります", message: "今すぐアップデートしますか？")
        .done { success in
            let url = URL(string: "https://itunes.apple.com/jp/app/id1525688066?mt=")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    self.firstFetchAll()//本来の処理を実施（遷移した後にアプリに戻した場合に、何もできなくなるのを回避）
                }
            }
        }
        .catch { (_) in //〔キャンセル〕ボタン押下時
            self.firstFetchAll()//本来の処理を実施
        }
        .finally {
        }
    }
    private func dispForceUpdateDialog() {
        self.showConfirm(title: "新しいバージョンがあります", message: "アップデートしてください。", onlyOK: true)
        .done { success in
            let url = URL(string: "https://itunes.apple.com/jp/app/id1525688066?mt=")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    //強制アップデートの場合には、アプリに戻ったときにロックされたままなのは、ある意味正しい
                }
            }
        }
        .catch { (_) in //〔キャンセル〕ボタン押下時
        }
        .finally {
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chkNeedUpdate()//アップデートチェック
    }
    func firstFetchAll() {
        self.fetchGetProfile()//とりあえず、プロフィール取得させてみる
    }
    func transitionToDeepLinkDestination(with hierarchy: DeepLinkHierarchy) {
        guard let rootNavigationController = hierarchy.rootNavigation,
            let destinationViewController = hierarchy.distination else { return }
        rootNavigationController.popToRootViewController(animated: false)
        rootNavigationController.pushViewController(destinationViewController, animated: true)
    }
    func switchNextVC() {
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
        if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            if version != build {
                disp = "Version: \(version) (\(build))"
            }
        }
        let attrDisp = TudTool.attrText(text: disp, fontType: .font_SS, textColor: UIColor(colorType: .color_light_gray)!, alignment: .left)
        lblVerStatus.attributedText = attrDisp
    }
}

//=== 画面振り分け
extension LaunchVC {
    func switchRootVC() {
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

extension LaunchVC {
    func fetchGetProfile() {
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

}
