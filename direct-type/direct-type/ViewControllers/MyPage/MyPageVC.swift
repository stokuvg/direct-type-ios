//
//  MyPageVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import PromiseKit
import SVProgressHUD
import SwaggerClient

//[H-1]
class MyPageVC: TmpNaviTopVC {
    private var profile: MdlProfile? = nil
    private var resume: MdlResume? = nil
    private var career: MdlCareer? = nil
    private var entry: MdlEntry? = nil
    private var topRanker: ChemistryScoreCalculation.TopRanker?

    @IBOutlet private weak var pageTableView: UITableView!

    private var carrerFlag: Bool {
        return career != nil
    }
    private var isExistsChemistry: Bool {
        return topRanker != nil
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGetEntryAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
private extension MyPageVC {
    func transitionToChemistry() {
        var vc = UIViewController()
        vc = UIStoryboard(name: "ChemistryStart", bundle: nil).instantiateInitialViewController() as! ChemistryStart
        if let topRanker = topRanker {
            vc = getVC(sbName: "ChemistryResult", vcName: "ChemistryResult") as! ChemistryResult
            (vc as! ChemistryResult).configure(with: topRanker)
        }
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = false
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
                if carrerFlag && isExistsChemistry {
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
                return isExistsChemistry ? 47 : 205
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
        case (0, 1):
            pushViewController(.profilePreviewH2, model: profile)
        case (0, 2):
            pushViewController(.resumePreviewH3, model: resume)
        case (1, 0):
            if carrerFlag {
                pushViewController(.careerListC, model: career)//既存の表示
            } else {
                registChemistryAction()//新規作成させる場合
            }
        case (2, 0):
            transitionToChemistry()
        case (3,_):
            let vc = getVC(sbName: "SettingVC", vcName: "SettingVC") as! SettingVC
            navigationController?.pushViewController(vc, animated: true)
        default:
            print(section, row)
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
                if isExistsChemistry {
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
                self.pushViewController(.profilePreviewH2)
            case 2:
                self.pushViewController(.resumePreviewH3)
            default:
                break
        }
    }

}

extension MyPageVC: MyPageCarrerStartCellDelegate {

    // 画面遷移
    func registCarrerAction() {
        //pushViewController(.careerListC)// 職歴書
        //[Dbg:遷移先画面の選択]___
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        let alert: UIAlertController = UIAlertController(title: "[Dbg: 開発)中]", message: "遷移先画面の選択", preferredStyle:  .alert)
        let action01: UIAlertAction = UIAlertAction(title: "[H-2] 個人プロフィール確認", style: .default, handler: { action in
            self.pushViewController(.profilePreviewH2)
        })
        let action02: UIAlertAction = UIAlertAction(title: "[H-3] 履歴書確認", style: .default, handler: { action in
            self.pushViewController(.resumePreviewH3)
        })
        let action03: UIAlertAction = UIAlertAction(title: "[C-15] 職務経歴書確認", style: .default, handler: { action in
            self.pushViewController(.careerPreviewC15)
        })
        let action04: UIAlertAction = UIAlertAction(title: "[F-11] サクサク職歴", style: .default, handler: { action in
            self.pushViewController(.smoothCareerPreviewF11)
        })
        let action05: UIAlertAction = UIAlertAction(title: "A[系統] 初期入力", style: .default, handler: { action in
            self.pushViewController(.firstInputPreviewA)
        })
        let action06: UIAlertAction = UIAlertAction(title: "C[仮] 職歴一覧", style: .default, handler: { action in
            self.pushViewController(.careerListC)
        })
        let action08: UIAlertAction = UIAlertAction(title: "[C-9] 応募フォーム", style: .default, handler: { action in
            let jobCard: MdlJobCardDetail = MdlJobCardDetail(
                jobCardCode: "12345678", jobName: "【PL候補・SE】案件数に絶対的な自信あり！◆月給40万円〜■残業平均月12h",
                salaryMinId: 3, salaryMaxId: 8,
                isSalaryDisplay: true, salaryOffer: "",
                workPlaceCodes: [11, 22, 33], companyName: "株式会社プレーンナレッジシステムズ（ヒューマンクリエイショングループ）",
                start_date: "", end_date: "",
                mainPicture: "", subPictures: [],
                mainTitle: "", mainContents: "",
                prCodes: [1,3,5], salarySample: "",
                recruitmentReason: "", jobDescription: "",
                jobExample: "", product: "", scope: "",
                spotTitle1: "", spotDetail1: "", spotTitle2: "", spotDetail2: "",
                qualification: "", betterSkill: "", applicationExample: "",
                suitableUnsuitable: "", notSuitableUnsuitable: "",
                employmentType: 2, salary: "", bonusAbout: "", jobtime: "",
                overtimeCode: 1, overtimeAbout: "", workPlace: "", transport: "",
                holiday: "", welfare: "", childcare: "", interviewMemo: "",
                selectionProcess: JobCardDetailSelectionProcess(selectionProcess1: "", selectionProcess2: "", selectionProcess3: "", selectionProcess4: "", selectionProcess5: "", selectionProcessDetail: ""),
                contactInfo: JobCardDetailContactInfo(companyUrl: "", contactZipcode: "", contactAddress: "", contactPhone: "", contactPerson: "", contactMail: ""),
                companyDescription: JobCardDetailCompanyDescription(enterpriseContents: "", mainCustomer: "", mediaCoverage: "", established: "", employeesCount: JobCardDetailCompanyDescriptionEmployeesCount(count: nil, averageAge: nil, genderRatio: nil, middleEnter: nil)
                    , capital: nil, turnover: nil, presidentData: JobCardDetailCompanyDescriptionPresidentData(presidentName: "", presidentHistory: "")),
                userFilter: UserFilterInfo(tudKeepStatus: false, tudSkipStatus: false),
                entryQuestion1: "企業独自の質目項目1", entryQuestion2: nil, entryQuestion3: "企業独自質問（歯抜け指定は仕様上は来ない想定になっているようです）" )
            self.pushViewController(.entryForm, model: jobCard)
        })
        alert.addAction(action01)
        alert.addAction(action02)
        alert.addAction(action06)
        //alert.addAction(action03)
        //alert.addAction(action04)
        alert.addAction(action05)
        alert.addAction(action08)

        let action07: UIAlertAction = UIAlertAction(title: "レコメンド[ap341]", style: .default, handler: { action in
            RecommendManager.fetchRecommend(type: .ap341, jobID: "123456789")
            .done { result in
                print("成功 [\(result)]")
            }
            .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                print("エラー[\(myErr.debugDisp)]")
            }
            .finally {
            }
        })

        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        alert.addAction(action07)

        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        //[Dbg:遷移先画面の選択]^^^
        
        
    }
}

extension MyPageVC: MyPageChemistryStartCellDelegate {
    // 相性診断画面遷移
    func registChemistryAction() {
        transitionToChemistry()
    }
}



//=== APIフェッチ
extension MyPageVC {
    private func fetchGetEntryAll() {
        fetchGetProfile()//ここから多段で実施してる
    }
    private func fetchGetProfile() {
        SVProgressHUD.show(withStatus: "情報の取得")
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            self.profile = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.fetchGetResume()
        }
    }
    private func fetchGetResume() {
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            self.resume = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.fetchGetCareerList()
        }
    }
    private func fetchGetCareerList() {
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            //!!!self.career = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            SVProgressHUD.dismiss()
            self.fetchGetChemistryData()//別途、読んでおく
        }
    }
    //TODO: APIの呼び出し方NG。ApiManager.getChemistryを作成して実施（これだと認証管理やリトライ管理ができてない）
    private func fetchGetChemistryData() {
        //SVProgressHUD.show(withStatus: "データ取得中")
        ChemistryAPI.chemistryControllerGet()
        .done { result -> Void in
            var firstRanker: ChemistryPersonalityType! = nil
            var secondRanker: ChemistryPersonalityType? = nil
            var thirdRanker: ChemistryPersonalityType? = nil
            result.chemistryTypeIds.enumerated().forEach { (index, typeIdText) in
                switch index {
                case 0:
                    firstRanker = ChemistryPersonalityType(rawValue: Int(typeIdText)!)
                case 1:
                    secondRanker = ChemistryPersonalityType(rawValue: Int(typeIdText)!)
                case 2:
                    thirdRanker = ChemistryPersonalityType(rawValue: Int(typeIdText)!)
                default:
                    break
                }
            }
            self.topRanker = ChemistryScoreCalculation.TopRanker(first: firstRanker, second: secondRanker, third: thirdRanker)
        }
        .catch { error in
        }
        .finally {
            self.pageTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}
