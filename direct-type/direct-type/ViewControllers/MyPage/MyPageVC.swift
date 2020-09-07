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

//[H-1]
final class MyPageVC: TmpNaviTopVC {
    private var profile: MdlProfile? = nil
    private var resume: MdlResume? = nil
    private var career: MdlCareer? = nil
    private var topRanker: ChemistryScoreCalculation.TopRanker? = nil
    //===フェッチ抑止処理
    var lastDispUpdateProfile: Date = Date(timeIntervalSince1970: 0)
    var lastDispUpdateResume: Date = Date(timeIntervalSince1970: 0)
    var lastDispUpdateCareerList: Date = Date(timeIntervalSince1970: 0)
    var lastDispUpdateTopRanker: Date = Date(timeIntervalSince1970: 0)
    
    var updateCnt:Int = 0

    @IBOutlet private weak var pageTableView: UITableView!

    private var isExistCareer: Bool {
        return career != nil
    }
    private var isExistsChemistry: Bool {
        return topRanker != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.delegate = self
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGetMyPageAll()
    }
    
    private func editUserName() {
        let tfNickname = UITextField()
        tfNickname.placeholder = "8文字まで"
        tfNickname.attributedPlaceholder = NSAttributedString(string: "8文字まで", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_light_gray) as Any])
        let alert = UIAlertController(title: "ニックネームの変更", message: "新しいニックネームを入力してください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "変更", style: .default) { (action:UIAlertAction) in
            if let tfNickname = alert.textFields?.first {
                let bufNickame: String = tfNickname.text ?? ""
                
                Log.selectLog(logLevel: .debug, "bufNickame.count:\(bufNickame.count)")

                //バリデーション 8文字を超える場合
                if bufNickame.count > 8 {
                    self.showConfirm(title: "９文字以上入力出来ません。", message: "", onlyOK: true)
                    .done { } .catch { (error) in } .finally {}
                } else {
                    self.fetchUpdateProfileNickname(bufNickame)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField { (tfNickname) in
            tfNickname.text = self.profile?.nickname ?? "ゲストさん"
            tfNickname.placeholder = "8文字まで"
            tfNickname.attributedPlaceholder = NSAttributedString(string: "8文字まで", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_light_gray) as Any])
        }
        present(alert, animated: true, completion: nil)
    }
}

private extension MyPageVC {
    func setup() {
        title = "マイページ"

        pageTableView.backgroundColor = UIColor.init(colorType: .color_base)
        pageTableView.tableFooterView = UIView()

        pageTableView.registerNib(nibName: "MyPageNameCell", idName: "MyPageNameCell") // アイコン
        pageTableView.registerNib(nibName: "BasePercentageCompletionCell", idName: "BasePercentageCompletionCell")// プロフィール
        // 履歴書
        // スカウト MVPでは外す
        pageTableView.registerNib(nibName: "MyPageCarrerStartCell", idName: "MyPageCarrerStartCell") // 職務経歴
        pageTableView.registerNib(nibName: "MyPageEditedCarrerCell", idName: "MyPageEditedCarrerCell")
        pageTableView.registerNib(nibName: "MyPageChemistryStartCell", idName: "MyPageChemistryStartCell") // 相性診断
        pageTableView.registerNib(nibName: "MyPageEditedChemistryCell", idName: "MyPageEditedChemistryCell")
        pageTableView.registerNib(nibName: "MyPageSettingCell", idName: "MyPageSettingCell") // 設定
    }
    
    func transitionToChemistry() {
        let isExistsData = topRanker != nil
        var vc = UIViewController()
        if isExistsData, let topRanker = topRanker {
            let result = UIStoryboard(name: "ChemistryResult", bundle: nil).instantiateInitialViewController() as! ChemistryResult
            result.configure(with: topRanker)
            vc = result
        } else {
            vc = UIStoryboard(name: "ChemistryStart", bundle: nil).instantiateInitialViewController() as! ChemistryStart
        }
        
        // 次画面は下部のTabBarを非表示にするため、hidesBottomBarWhenPushed を true にする。
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = false
    }

    func transitionToSetting() {
        let vc = getVC(sbName: "SettingVC", vcName: "SettingVC") as! SettingVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyPageVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = .clear
        return spaceView
    }

    var sectionHeaderHeight: CGFloat { return 15 }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = SectionType(rawValue: section)!

        switch sectionType {
        case .resume:
            return sectionHeaderHeight
        case .chemistry:
            guard isExistCareer && isExistsChemistry else {
                return sectionHeaderHeight
            }
            return .zero
        case .top, .setting:
            return .zero
        }
    }

    var sectionFooterHeight: CGFloat { return 15 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spaceView = UIView.init()
        spaceView.backgroundColor = UIColor.clear
        return spaceView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionType = SectionType(rawValue: section)!

        switch sectionType {
        case .chemistry, .setting:
            return sectionFooterHeight
        case .top, .resume:
            return .zero
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = CellType(indexPath)

        switch cellType {
        case .userName:
            return 136
        case .profileCompleteness, .resumeCompleteness:
            return 58
        case .editableCarrer:
            return isExistCareer ? 47 : 205
        case .editableChemistry:
            return isExistsChemistry ? 47 : 205
        case .setting:
            return 50
        case .unknown:
            return .zero
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = CellType(indexPath)

        switch cellType {
            case .userName:
                self.editUserName()
            case .profileCompleteness:
                pushViewController(.profilePreviewH2, model: profile)
            case .resumeCompleteness:
                pushViewController(.resumePreviewH3(false), model: resume)
            case .editableCarrer:
                isExistCareer ? pushViewController(.careerListC, model: career) : registCarrerAction()
            case .editableChemistry:
                transitionToChemistry()
            case .setting:
                transitionToSetting()
            case .unknown:
                break
        }
    }
}

extension MyPageVC: UITableViewDataSource {
    enum SectionType: Int, CaseIterable {
        case top
        case resume
        case chemistry
        case setting

        var cellCount: Int {
            switch self {
            case .top:
                return 3
            case .resume:
                return 1
            case .chemistry:
                return 1
            case .setting:
                return 1
            }
        }
    }

    enum CellType {
        case userName
        case profileCompleteness
        case resumeCompleteness
        case editableCarrer
        case editableChemistry
        case setting
        case unknown

        init(_ indexPath: IndexPath) {
            let sectionType = SectionType(rawValue: indexPath.section)!
            switch sectionType {
            case .top:
                switch indexPath.row {
                case 0:
                    self = .userName
                case 1:
                    self = .profileCompleteness
                case 2:
                    self = .resumeCompleteness
                default:
                    self = .unknown
                }
            case .resume:
                self = .editableCarrer
            case .chemistry:
                self = .editableChemistry
            case .setting:
                self = .setting
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType(rawValue: section)!.cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let cellType = CellType(indexPath)

        switch cellType {
            case .userName:
                cell =  tableView.loadCell(cellName: "MyPageNameCell", indexPath: indexPath) as! MyPageNameCell
                (cell as! MyPageNameCell).initCell(profile?.nickname ?? "ゲストさん")
//                (cell as! MyPageNameCell).initCell(self, profile?.nickname ?? "ゲストさん")
                (cell as! MyPageNameCell).dispCell()
        case .profileCompleteness:
            cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
            (cell as! BasePercentageCompletionCell).setup(title: "プロフィールの完成度", percent: String(profile?.completeness ?? 0))
            (cell as! BasePercentageCompletionCell).delegate = self
        case .resumeCompleteness:
            cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
            (cell as! BasePercentageCompletionCell).setup(title: "履歴書の完成度", percent: String(resume?.completeness ?? 0))
            (cell as! BasePercentageCompletionCell).delegate = self
        case .editableCarrer:
            guard isExistCareer else {
                cell = tableView.loadCell(cellName: "MyPageCarrerStartCell", indexPath: indexPath) as! MyPageCarrerStartCell
                (cell as! MyPageCarrerStartCell).delegate = self
                return cell
            }
            cell = tableView.loadCell(cellName: "MyPageEditedCarrerCell", indexPath: indexPath) as! MyPageEditedCarrerCell
        case .editableChemistry:
            guard isExistsChemistry else {
                cell = tableView.loadCell(cellName: "MyPageChemistryStartCell", indexPath: indexPath) as! MyPageChemistryStartCell
                (cell as! MyPageChemistryStartCell).delegate = self
                return cell
            }
            cell = tableView.loadCell(cellName: "MyPageEditedChemistryCell", indexPath: indexPath) as! MyPageEditedChemistryCell
        case .setting:
            cell = tableView.loadCell(cellName: "MyPageSettingCell", indexPath: indexPath) as! MyPageSettingCell
        case .unknown:
            cell = UITableViewCell()
        }
        return cell
    }
}

extension MyPageVC: BasePercentageCompletionCellDelegate {
    func completionEditAction(sender: BaseTableViewCell) {
        switch sender {
        case is MyPageEditedCarrerCell:
            pushViewController(.profilePreviewH2)
        case is MyPageEditedChemistryCell:
            pushViewController(.resumePreviewH3(false))
        default:
            break
        }
    }
}

extension MyPageVC: MyPageCarrerStartCellDelegate {
    func registCarrerAction() {
        pushViewController(.careerListC)
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
    func fetchGetMyPageAll() {
        fetchGetProfile()//ここから多段で実施してる
    }

    func fetchGetProfile() {
        SVProgressHUD.show(withStatus: "情報の取得")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        var isNeedFetch: Bool = ApiManager.needFetch(.profile, lastDispUpdateProfile)
        if self.profile == nil { isNeedFetch = true } //モデル未取得ならフェッチが必要
        guard isNeedFetch else {
//            Log.selectLog(logLevel: .debug, "fetchGetProfile 読み込み不要")
            self.fetchGetResume()//次の処理の呼び出し
            return
        }
        LogManager.appendApiLog("getProfile", Void(), function: #function, line: #line)
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getProfile", result, function: #function, line: #line)
//            Log.selectLog(logLevel: .debug, "fetchGetProfile 読み込みstart")
            self.profile = result
            self.lastDispUpdateProfile = Date()//取得したデータで表示更新するので
//            Log.selectLog(logLevel: .debug, "lastDispUpdateProfile:\(self.lastDispUpdateProfile)")
            self.updateCnt += 1
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getProfile", error, function: #function, line: #line)
//            Log.selectLog(logLevel: .debug, "fetchGetProfile 読み込みerror")
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
            
        }
        .finally {
            self.fetchGetResume()//次の処理の呼び出し
        }
    }

    func fetchGetResume() {
        var isNeedFetch: Bool = ApiManager.needFetch(.resume, lastDispUpdateResume)
        if self.resume == nil { isNeedFetch = true } //モデル未取得ならフェッチが必要
        guard isNeedFetch else {
//            Log.selectLog(logLevel: .debug, "fetchGetResume 読み込み不要")
            self.fetchGetCareerList()//次の処理の呼び出し
            return
        }
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
//            Log.selectLog(logLevel: .debug, "fetchGetResume 読み込みstart")
            self.resume = result
            self.lastDispUpdateResume = Date()//取得したデータで表示更新するので
//            Log.selectLog(logLevel: .debug, "lastDispUpdateResume:\(self.lastDispUpdateResume)")
            self.updateCnt += 1
        }
        .catch { (error) in
//            Log.selectLog(logLevel: .debug, "fetchGetResume 読み込みerror")
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.fetchGetCareerList()//次の処理の呼び出し
        }
    }

    func fetchGetCareerList() {
        var isNeedFetch: Bool = ApiManager.needFetch(.careerList, lastDispUpdateCareerList)
        if self.career == nil { isNeedFetch = true } //モデル未取得ならフェッチが必要
        guard isNeedFetch else {
//            Log.selectLog(logLevel: .debug, "fetchGetCareerList 読み込み不要")
            self.fetchGetChemistryData()//次の処理の呼び出し
            return
        }
//        Log.selectLog(logLevel: .debug, "fetchGetCareerList 読み込みstart")
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
//            Log.selectLog(logLevel: .debug, "fetchGetCareerList 読み込み結果")
            self.career = result
            self.lastDispUpdateCareerList = Date()//取得したデータで表示更新するので
//            Log.selectLog(logLevel: .debug, "lastDispUpdateCareerList:\(self.lastDispUpdateCareerList)")
            self.updateCnt += 1
        }
        .catch { (error) in
//            Log.selectLog(logLevel: .debug, "fetchGetCareerList 読み込みerror")
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404:
//                Log.selectLog(logLevel: .debug, "carrer未作成のため、updateCntは追加しない")
                break //未作成での404は許容
            default:
                print(myErr)
            }
        }
        .finally {
            self.fetchGetChemistryData()//次の処理の呼び出し
        }
    }

    func fetchGetChemistryData() {
        var isNeedFetch: Bool = ApiManager.needFetch(.topRanker, lastDispUpdateTopRanker)
        if self.topRanker == nil { isNeedFetch = true } //モデル未取得ならフェッチが必要
        guard isNeedFetch else {
//            Log.selectLog(logLevel: .debug, "fetchGetChemistryData 読み込み不要")
            self.fetchGroupeFinish()
            return
        }
//        Log.selectLog(logLevel: .debug, "fetchGetChemistryData 読み込みstart")
        ApiManager.getChemistry(Void(), isRetry: true)
        .done { result -> Void in
//            Log.selectLog(logLevel: .debug, "fetchGetChemistryData 読み込み結果")
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
            self.lastDispUpdateTopRanker = Date()//取得したデータで表示更新するので
//            Log.selectLog(logLevel: .debug, "lastDispUpdateTopRanker:\(self.lastDispUpdateTopRanker)")
            self.updateCnt += 1
        }
        .catch { error in
//            Log.selectLog(logLevel: .debug, "fetchGetChemistryData 読み込みerror")
        }
        .finally {
            self.fetchGroupeFinish()
        }
    }
    private func fetchGroupeFinish() {
//        Log.selectLog(logLevel: .debug, "fetchGroupeFinish start")
        
//        Log.selectLog(logLevel: .debug, "updateCnt:\(self.updateCnt)")
        
        self.pageTableView.reloadData()
        SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
    }
}

//=== ニックネームの変更処理
extension MyPageVC {
    private func fetchUpdateProfileNickname(_ nickname: String) {
        if nickname.isEmpty { return }
        let param = UpdateProfileRequestDTO(nickname: nickname, hopeJobPlaceIds: nil, familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
        SVProgressHUD.show(withStatus: "ニックネームの更新")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("updateProfile", param, function: #function, line: #line)
        ApiManager.updateProfile(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("updateProfile", result, function: #function, line: #line)
            self.profile?.nickname = nickname//ローカルで変更適用しておく
            self.pageTableView.reloadData()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("updateProfile", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
}

extension MyPageVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Log.selectLog(logLevel: .debug, "MyPageVC didSelect start")

        if let vcs = tabBarController.viewControllers {
            Log.selectLog(logLevel: .debug, "vcs:\(vcs)")
            
            let firstNavi = vcs.first as! BaseNaviController
            let firstVC = firstNavi.visibleViewController as! HomeVC
            
            Log.selectLog(logLevel: .debug, "firstVC:\(String(describing: firstVC))")
            
            if tabBarController.selectedIndex == 0 {
                Log.selectLog(logLevel: .debug, "切り替えた画面がHomeVC")
//                Log.selectLog(logLevel: .debug, "updateCnt:\(updateCnt)")
                if updateCnt > 0 {
//                    Log.selectLog(logLevel: .debug, "更新した部分がある")
                    firstVC.changeProfileFlag = true
                    updateCnt = 0
                }
            } else {
            }
        }
    }
}
