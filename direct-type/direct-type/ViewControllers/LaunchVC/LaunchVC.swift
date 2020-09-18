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
        chkNeedUpdate()//アップデートチェック
    }
    private func chkNeedUpdate() {
        //バージョンチェックなどするなら、ここで
        VersionCheckManager.getVersionInfo()
            .done { (isForce, storeVer) in
                let appVer = VersionCheckManager.getAppVersion()
                var updateTyep: VersionCheckManager.UpdateType = .none
                //===どのアップデート誘導ダイアログを表示するか
                switch appVer.checkVersion(target: storeVer) {
                case .same: break //公開中のバージョンと同じなので、何もしない
                case .older(_): updateTyep = isForce ? .force : .optional
                //case .older(let type): //majorが古いなら強制、minorなら任意などとルール決めされている場合
                //    switch type {
                //    case .major: updateTyep = .force
                //    case .minor: updateTyep = .optional
                //    case .patch: break //マイナーバージョンアップも誘導しない場合
                //    }
                case .newer(_): break //自分のバージョンの方が新しいので、何もしない
                }
                //===結果に応じて、画面遷移
                switch updateTyep {
                case .none: self.firstFetchAll()//本来の処理を実施
                case .optional: self.dispUpdateDialog()//アップデート誘導表示
                case .force: self.dispForceUpdateDialog()//強制アップデート表示
                }
            }
            .catch { (_) in
                //バージョン取得に失敗した場合、アプリを利用可能にして良いなら次の処理へ
                self.firstFetchAll()
            }
            .finally {
        }
    }
    private func firstFetchAll() {
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
extension LaunchVC {
    private func dispUpdateDialog() {
        let dialog = VersionCheckManager.shared.updateDialog
        self.showConfirm(title: dialog.updateTitle, message: dialog.updateMessage)
            .done { success in
                let url = URL(string: dialog.appStoreUrl)!
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
        let dialog = VersionCheckManager.shared.updateDialog
        self.showConfirm(title: dialog.updateTitle, message: dialog.updateMessage, onlyOK: true)
            .done { success in
                let url = URL(string: dialog.appStoreUrl)!
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
}
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
