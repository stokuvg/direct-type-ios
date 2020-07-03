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

class SettingVC: TmpBasicVC {
    @IBOutlet weak var tableView:UITableView!
    
    private enum DisplayCellType: Int, CaseIterable {
        case account
        case approach
        case help
        case privacyPolicy
        case termsOfService
        case logout
        case withdrawal
        
        var title: String {
            switch self {
            case .account, .approach:
                return ""
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
            case .help, .privacyPolicy, .termsOfService, .logout, .withdrawal:
                return 54
            }
        }
    }
    
    private var approachSetting = MdlApproach(isScoutEnable: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: サーバー側のAPI実装が完了した後に疎通実装を行う
        // fetchData()
        setup()
    }
}

private extension SettingVC {
    func setup() {
        title = "設定"
        
        tableView.backgroundColor = UIColor.init(colorType: .color_white)!
        tableView.tableFooterView = UIView()
        // アカウント
        tableView.registerNib(nibName: "SettingAccountCell", idName: "SettingAccountCell")
        // アプローチ
        tableView.registerNib(nibName: "SettingApproachCell", idName: "SettingApproachCell")
        // よくある質問
        // プライバシーポリシー
        // 利用規約
        // ログアウト
        // 退会
        tableView.registerNib(nibName: "SettingBaseCell", idName: "SettingBaseCell")
    }
    
    func fetchData() {
        SVProgressHUD.show(withStatus: "設定情報の取得")
        ApiManager.getApproach(())
            .done { result in
                self.approachSetting = result
        }
            .catch { (error) in
                let myError: MyErrorDisp = AuthManager.convAnyError(error)
                print("アプローチデータ取得エラー！　コード: \(myError.code)")
                self.showError(myError)
        }
            .finally {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
        }
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
                DispatchQueue.main.async {
                    self.showConfirm(title: "認証手順", message: "ログアウトしました", onlyOK: true)
                    .done { _ in
                        self.transitionToInitial()
                    }
                    .catch { _ in
                    }
                    .finally {
                        AnalyticsEventManager.track(type: .logout)
                    }
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
            let telephoneData = ["telNo":"090-1234-5678"]
            vc.configure(data: telephoneData)
            navigationController?.pushViewController(vc, animated: true)
        case .approach:
            // H-9 アプローチ設定へ遷移
            let vc = getVC(sbName: "SettingVC", vcName: "ApproachSettingVC") as! ApproachSettingVC
            vc.configure(with: approachSetting)
            navigationController?.pushViewController(vc, animated: true)
        case .help:
            // Web(よくある質問・ヘルプ)を表示
            let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
            vc.setup(type: .Help)
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true, completion: nil)
        case .privacyPolicy:
            // Web(プライバシーポリシー)を表示
            let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
            vc.setup(type: .Privacy)
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true, completion: nil)
        case .termsOfService:
            // Web(利用規約)を表示
            let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
            vc.setup(type: .Term)
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true, completion: nil)
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
            cell.setup(telNo: "090-1234-5678")
            return cell
        case .approach:
            let cell = tableView.loadCell(cellName: "SettingApproachCell", indexPath: indexPath) as! SettingApproachCell
            cell.configure(with: approachSetting)
            return cell
        case .help, .privacyPolicy, .termsOfService, .logout, .withdrawal:
            let cell = tableView.loadCell(cellName: "SettingBaseCell", indexPath: indexPath) as! SettingBaseCell
            cell.setup(title: cellType.title)
            return cell
        }
    }
}
