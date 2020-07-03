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
final class MyPageVC: TmpNaviTopVC {
    private var profile: MdlProfile? = nil
    private var resume: MdlResume? = nil
    private var career: MdlCareer? = nil
    private var entry: MdlEntry? = nil
    private var topRanker: ChemistryScoreCalculation.TopRanker?

    @IBOutlet private weak var pageTableView: UITableView!

    private var isExistCareer: Bool {
        return career != nil
    }
    private var isExistsChemistry: Bool {
        return topRanker != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGetEntryAll()
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
            return 126
        case .profileCompleteness, .resumeCompleteness:
            return 68
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
        case .profileCompleteness:
            pushViewController(.profilePreviewH2, model: profile)
        case .resumeCompleteness:
            pushViewController(.resumePreviewH3, model: resume)
        case .editableCarrer:
            isExistCareer ? pushViewController(.careerListC, model: career) : registChemistryAction()
        case .editableChemistry:
            transitionToChemistry()
        case .setting:
            transitionToSetting()
        case .userName, .unknown:
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
        var cell = UITableViewCell()
        let cellType = CellType(indexPath)

        switch cellType {
        case .userName:
            cell =  tableView.loadCell(cellName: "MyPageNameCell", indexPath: indexPath) as! MyPageNameCell
        case .profileCompleteness:
            cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
            (cell as! BasePercentageCompletionCell).setup(title: "プロフィールの完成度", percent: String(profile?.completeness ?? 0))
            (cell as! BasePercentageCompletionCell).delegate = self
        case .resumeCompleteness:
            cell = tableView.loadCell(cellName: "BasePercentageCompletionCell", indexPath: indexPath) as! BasePercentageCompletionCell
            (cell as! BasePercentageCompletionCell).setup(title: "履歴書の完成度", percent: "40")
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
            break
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
            pushViewController(.resumePreviewH3)
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
    func fetchGetEntryAll() {
        fetchGetProfile()//ここから多段で実施してる
    }

    func fetchGetProfile() {
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

    func fetchGetResume() {
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

    func fetchGetCareerList() {
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            self.career = result
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

    func fetchGetChemistryData() {
        ApiManager.getChemistry(Void(), isRetry: true)
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
