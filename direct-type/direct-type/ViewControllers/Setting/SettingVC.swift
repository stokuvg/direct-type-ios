//
//  SettingVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingVC: TmpBasicVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "設定"
        
        tableView.backgroundColor = UIColor.init(colorType: .color_white)!
        tableView.tableFooterView = UIView()

        self.tableView.registerNib(nibName: "SettingAccountCell", idName: "SettingAccountCell") // アカウント
        // アプローチ
        self.tableView.registerNib(nibName: "SettingApproachCell", idName: "SettingApproachCell")
        // よくある質問
        // プライバシーポリシー
        // 利用規約
        // ログアウト
        // 退会
        self.tableView.registerNib(nibName: "SettingBaseCell", idName: "SettingBaseCell")
    }
    
    private func dispLogoutAlert() {
        let logoutAlert = UIAlertController.init(title: "ログアウト確認", message: "ログアウトしますか", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
            
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) -> Void in
            
        })
        logoutAlert.addAction(cancelAction)
        logoutAlert.addAction(okAction)
        
        self.navigationController?.present(logoutAlert, animated: true, completion: nil)
    }

}

extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
            case 0:
                return 68
            /*
            case 1:
                return 68
            */
            default:
                return 54
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
            case 0:
                // H-10 修正画面へ遷移
                let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeVC") as! AccountChangeVC
                let telephoneData = ["telNo":"090-1234-5678"]
                vc.setup(data: telephoneData)
                self.navigationController?.pushViewController(vc, animated: true)
            /*
            case 1:
                // H-9 アプローチ設定へ遷移
                break
            */
            case 1:
                // Web(よくある質問・ヘルプ)を表示
                let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
                vc.setup(type: .Help)
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            case 2:
                // Web(プライバシーポリシー)を表示
                let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
                vc.setup(type: .Privacy)
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            case 3:
                // Web(利用規約)を表示
                let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
                vc.setup(type: .Term)
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            case 4:
                // ログアウト
                //self.dispLogoutAlert()
                //[Dbg: 仮認証画面]
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CognitoAuthVC") as? CognitoAuthVC{
                    self.navigationController?.pushViewController(nvc, animated: true)
                }

            
            case 5:
                // 退会
                let vc = getVC(sbName: "SettingVC", vcName: "WithDrawalVC") as! WithDrawalVC
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
        }
    }
}

extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            case 0:
                let cell = tableView.loadCell(cellName: "SettingAccountCell", indexPath: indexPath) as! SettingAccountCell
                cell.setup(telNo: "090-1234-5678")
                return cell
            /*
            case 1:
                let cell = tableView.loadCell(cellName: "SettingApproachCell", indexPath: indexPath) as! SettingApproachCell
                let data:[String:Any] = [:]
                cell.setup(data: data)
                return cell
            */
            default:
                let cell = tableView.loadCell(cellName: "SettingBaseCell", indexPath: indexPath) as! SettingBaseCell
                var titleStirng = ""
                switch row {
                    case 1:
                        titleStirng = "よくある質問・ヘルプ"
                    case 2:
                        titleStirng = "プライバシーポリシー"
                    case 3:
                        titleStirng = "利用規約"
                    case 4:
                        titleStirng = "ログアウト"
                    case 5:
                        titleStirng = "退会"
                    default:
                        titleStirng = ""
                }
                cell.setup(title: titleStirng)
                return cell
        }
    }
    
    
}
