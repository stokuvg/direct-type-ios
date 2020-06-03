//
//  MyPageVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//[H-1]
class MyPageVC: TmpNaviTopVC {
    
    @IBOutlet weak var pageTableView:UITableView!
    //さくさく職歴書
    @IBOutlet weak var btnButton04: UIButton!
    @IBAction func actButton04(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //認証
    @IBOutlet weak var btnButton05: UIButton!
    @IBAction func actButton05(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CognitoAuthVC") as? CognitoAuthVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }

    //Get Jobs
    @IBOutlet weak var btnButton06: UIButton!
    @IBAction func actButton06(_ sender: UIButton) {
        fetchGetJobList()
    }
    
    var carrerFlag:Bool = false
    var chemistryFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "マイページ"
        
        self.pageTableView.backgroundColor = UIColor.init(colorType: .color_base)
        self.pageTableView.tableFooterView = UIView()
        
        self.pageTableView.registerNib(nibName: "MyPageNameCell", idName: "MyPageNameCell") // アイコン
        self.pageTableView.registerNib(nibName: "BasePercentageCompletionCell", idName: "BasePercentageCompletionCell")// プロフィール
        // 履歴書
        // スカウト MVPでは外す
        
        self.pageTableView.registerNib(nibName: "MyPageCarrerStartCell", idName: "MyPageCarrerStartCell") // 職務経歴
        self.pageTableView.registerNib(nibName: "MyPageEditedCarrerCell", idName: "MyPageEditedCarrerCell")
        
        self.pageTableView.registerNib(nibName: "MyPageChemistryStartCell", idName: "MyPageChemistryStartCell") // 相性診断
        self.pageTableView.registerNib(nibName: "MyPageEditedChemistryCell", idName: "MyPageEditedChemistryCell")
        
        self.pageTableView.registerNib(nibName: "MyPageSettingCell", idName: "MyPageSettingCell") // 設定
    }
}


//=== APIフェッチ
extension MyPageVC {
    private func fetchGetJobList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        ApiManager.getJobs(Void(), isRetry: true)
        .done { result in
            print(result.debugDisp)
        }
        .catch { (error) in
            self.showError(error)
        }
        .finally {
        }
    }
}

extension MyPageVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spaceView = UIView.init()
        spaceView.backgroundColor = UIColor.clear
        return spaceView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 1:
                return 15
            case 2:
                if carrerFlag && chemistryFlag {
                    return 0
                }
                return 15
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spaceView = UIView.init()
        spaceView.backgroundColor = UIColor.clear
        return spaceView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 15
        case 3:
            return 15
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                return 126
            case (0,_):
                return 68
            case (1,0):
                return carrerFlag ? 47 : 205
            case (2,0):
                return chemistryFlag ? 47 : 205
            case (3,_):
                return 50
            default:
                return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch (section,row) {
            case (3,_):
//                actButton05(UIButton())//[Dbg: 仮認証]
                let vc = getVC(sbName: "SettingVC", vcName: "SettingVC") as! SettingVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
        }
    }
}

extension MyPageVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 3
            case 1:
                return 1
            case 2:
                return 1
            case 3:
                return 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch (section,row) {
            case (0,0):
                return tableView.loadCell(cellName: "MyPageNameCell", indexPath: indexPath) as! MyPageNameCell
            case (0,1):
                let cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
                cell.setup(title: "プロフィールの完成度", percent: "100")
                cell.tag = row
                cell.delegate = self
                return cell
            case (0,2):
                let cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
                cell.setup(title: "履歴書の完成度", percent: "40")
                cell.tag = row
                cell.delegate = self
                return cell
            case (1,0):
                if carrerFlag {
                    let cell = tableView.loadCell(cellName: "MyPageEditedCarrerCell", indexPath: indexPath) as! MyPageEditedCarrerCell
                    return cell
                } else {
                    let cell = tableView.loadCell(cellName: "MyPageCarrerStartCell", indexPath: indexPath) as! MyPageCarrerStartCell
                    cell.delegate = self
                    return cell
                }
            case (2,0):
                if chemistryFlag {
                    let cell = tableView.loadCell(cellName: "MyPageEditedChemistryCell", indexPath: indexPath) as! MyPageEditedChemistryCell
                    return cell
                } else {
                    let cell = tableView.loadCell(cellName: "MyPageChemistryStartCell", indexPath: indexPath) as! MyPageChemistryStartCell
                    cell.delegate = self
                    return cell
                }
            case (3,_):
                let cell = tableView.loadCell(cellName: "MyPageSettingCell", indexPath: indexPath) as! MyPageSettingCell
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    
}

extension MyPageVC: BasePercentageCompletionCellDelegate {
    func completionEditAction(tagNo: Int) {
        switch tagNo {
            case 1:
                let storyboard = UIStoryboard(name: "Preview", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfilePreviewVC") as? ProfilePreviewVC{
                    self.navigationController?.pushViewController(nvc, animated: true)
                }
            case 2:
                let storyboard = UIStoryboard(name: "Preview", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ResumePreviewVC") as? ResumePreviewVC{
                    self.navigationController?.pushViewController(nvc, animated: true)
                }
            default:
                break
        }
    }
    
}

extension MyPageVC: MyPageCarrerStartCellDelegate {
    
    // 画面遷移
    func registCarrerAction() {
        // 職歴書
        /*
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
        */
        
        // サクサク
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
}

extension MyPageVC: MyPageChemistryStartCellDelegate {
    
    // 相性診断画面遷移
    func registChemistryAction() {
    }
}
