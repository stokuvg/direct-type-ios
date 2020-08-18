//
//  SettingVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD
import AWSMobileClient

final class SettingVC: TmpBasicVC {
    @IBOutlet private weak var tableView:UITableView!
    
    private enum DisplayCellType: Int, CaseIterable {
        case account
        case approach
        case howto
        case help
        case privacyPolicy
        case termsOfService
        case logout
        case withdrawal
        
        var title: String {
            switch self {
            case .account, .approach:
                return ""
            case .howto:
                return "使い方"
            case .help:
                return "よくある質問・ヘルプ"
            case .privacyPolicy:
                return "プライバシーポリシー"
            case .termsOfService:
                return "利用規約"
            case .logout:
                return "ログアウト"
            case .withdrawal:
                return "退会"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .account, .approach:
                return 68
            case .help, .howto, .privacyPolicy, .termsOfService, .logout, .withdrawal:
                return 54
            }
        }
    }
    
    private var profile: MdlProfile?
    private var approachSetting = MdlApproach(scoutEnable: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileData()
    }
}

private extension SettingVC {
    func setup() {
        title = "設定"
        
        tableView.backgroundColor = UIColor(colorType: .color_white)!
        tableView.tableFooterView = UIView()
        // アカウント
        tableView.registerNib(nibName: "SettingAccountCell", idName: "SettingAccountCell")
        // アプローチ
        tableView.registerNib(nibName: "SettingApproachCell", idName: "SettingApproachCell")
        // 使い方
        // よくある質問
        // プライバシーポリシー
        // 利用規約
        // ログアウト
        // 退会
        tableView.registerNib(nibName: "SettingBaseCell", idName: "SettingBaseCell")
    }
    
    func dispLogoutAlert() {
        let logoutAlert = UIAlertController.init(title: "ログアウト確認", message: "ログアウトしますか", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) -> Void in
            AWSMobileClient.default().signOut { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showError(error)
                    }
                    return
                }
                //AWSCognitoAuth.default().signOutLocallyAndClearLastKnownUser()//サインアウト時の後処理（これ使う場合には、Info.plistにユーザプールID定義する必要あり）
                DispatchQueue.main.async {
                    self.showConfirm(title: "認証手順", message: "ログアウトしました", onlyOK: true)
                    .done { _ in
                        self.transitionToInitial()
                        AnalyticsEventManager.track(type: .logout)
                    }
                    .catch { error in
                        self.showConfirm(title: "エラー", message: error.localizedDescription, onlyOK: true)
                    }
                    .finally {}
                }
            }
        })
        logoutAlert.addAction(cancelAction)
        logoutAlert.addAction(okAction)
        
        navigationController?.present(logoutAlert, animated: true, completion: nil)
    }
    
    func transitionToInitial() {
        let vc = getVC(sbName: "InitialInputStartVC", vcName: "InitialInputStartVC") as! InitialInputStartVC
        let newNavigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = newNavigationController
    }
}

extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = DisplayCellType(rawValue: indexPath.row)!
        return cellType.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = DisplayCellType(rawValue: indexPath.row)!
        
        switch cellType {
        case .account:
            // H-10 修正画面へ遷移
            let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeVC") as! AccountChangeVC
            if let profile = profile {
                vc.configure(with: profile)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .approach:
            // H-9 アプローチ設定へ遷移
            let vc = getVC(sbName: "SettingVC", vcName: "ApproachSettingVC") as! ApproachSettingVC
            navigationController?.pushViewController(vc, animated: true)
        case .howto:
            // Web(使い方)を表示
            OpenLinkUrlTool.open(type: .SettingsHowTo, navigationController)
        case .help:
            // Web(よくある質問・ヘルプ)を表示
            OpenLinkUrlTool.open(type: .SettingsFAQ, navigationController)
        case .privacyPolicy:
            // Web(プライバシーポリシー)を表示
            OpenLinkUrlTool.open(type: .SettingsPrivacyPolicy, navigationController)
        case .termsOfService:
            // Web(利用規約)を表示
            OpenLinkUrlTool.open(type: .SettingsAgreement, navigationController)
        case .logout:
            // ログアウト
            dispLogoutAlert()
        case .withdrawal:
            // 退会
            let vc = getVC(sbName: "SettingVC", vcName: "WithDrawalVC") as! WithDrawalVC
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisplayCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = DisplayCellType(rawValue: indexPath.row)!
        switch cellType {
        case .account:
            let cell = tableView.loadCell(cellName: "SettingAccountCell", indexPath: indexPath) as! SettingAccountCell
            if let phoneNumber = profile?.mobilePhoneNo {
                cell.setup(telNo: phoneNumber)
            }
            return cell
        case .approach:
            let cell = tableView.loadCell(cellName: "SettingApproachCell", indexPath: indexPath) as! SettingApproachCell
            cell.configure(with: approachSetting)
            return cell
        case .help, .howto, .privacyPolicy, .termsOfService, .logout, .withdrawal:
            let cell = tableView.loadCell(cellName: "SettingBaseCell", indexPath: indexPath) as! SettingBaseCell
            cell.setup(title: cellType.title)
            return cell
        }
    }
}

// API　データフェッチ
extension SettingVC {
    func fetchProfileData() {
        ApiManager.getProfile(())
        .done { result in
            self.profile = result
        }
        .catch { (error) in
            let myError: MyErrorDisp = AuthManager.convAnyError(error)
            print("アプローチデータ取得エラー！　コード: \(myError.code)")
            self.showError(myError)
        }
        .finally {
            self.fetchApproachData()
        }
    }
    
    func fetchApproachData() {
        SVProgressHUD.show(withStatus: "設定情報の取得")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("getApproach", nil, function: #function, line: #line)
        ApiManager.getApproach(())
        .done { result in
            LogManager.appendApiResultLog("getApproach", result, function: #function, line: #line)
            self.approachSetting = result
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getApproach", error, function: #function, line: #line)
            let myError: MyErrorDisp = AuthManager.convAnyError(error)
            print("アプローチデータ取得エラー！　コード: \(myError.code)")
            self.showError(myError)
        }
        .finally {
            self.tableView.reloadData()
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
}
