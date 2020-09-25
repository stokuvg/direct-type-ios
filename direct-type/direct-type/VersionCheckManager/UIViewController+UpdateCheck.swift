//
//  UIViewController+UpdateCheck.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//===強制アップデート関連
extension UIViewController {
    func chkNeedUpdate(completion: @escaping () -> Void) {
        VersionCheckManager.getVersionInfo()
        .done { (jsonVer, isForce) in
            let appVer = VersionCheckManager.getAppVersion()
            var updateTyep: VersionCheckManager.UpdateType = .none
            //===どのアップデート誘導ダイアログを表示するか
            switch appVer.checkVersion(target: jsonVer) {
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
            case .none:     completion()//継続処理を実施
            case .optional: self.dispUpdateDialog(completion)//アップデート誘導表示
            case .force:    self.dispForceUpdateDialog(completion)//強制アップデート表示
            }
        }
        .catch { (_) in
            //バージョン取得に失敗した場合、アプリを利用可能にして良いなら次の処理へ
            completion()//継続処理を実施
        }
        .finally {
        }
    }
}

// 1) chkNeedUpdate()   強制アップデートが必要か確認し、誘導する
extension UIViewController {
    private func dispUpdateDialog(_ completion: @escaping () -> Void) {
        dispUpdateDialog(false, completion)
    }
    private func dispForceUpdateDialog(_ completion: @escaping () -> Void) {
        dispUpdateDialog(true, completion)
    }
    private func dispUpdateDialog(_ isForce: Bool, _ completion: @escaping () -> Void) {
        //既存のポップアップが存在していたら閉じておく
        if let popupWindow = self.presentedViewController {
            popupWindow.dismiss(animated: false, completion: nil)
        }
        //ダイアログを表示する
        let dialog = VersionCheckManager.shared.updateDialog
        let alert = UIAlertController.init(title: dialog.updateTitle, message: dialog.updateMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { _ in
            let url = URL(string: dialog.appStoreUrl)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if !isForce {
                        completion()//本来の処理を実施（遷移した後にアプリに戻した場合に、何もできなくなるのを回避）
                    }
                }
            }
        }
        if !isForce {
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { _ in
                completion()//本来の処理を実施
            }
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
