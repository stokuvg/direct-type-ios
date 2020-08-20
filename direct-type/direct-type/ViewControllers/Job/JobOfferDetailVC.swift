//
//  JobOfferDetailVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import SVProgressHUD
import PromiseKit

final class JobOfferDetailVC: TmpBasicVC {
    @IBOutlet private weak var detailTableView:UITableView!
    @IBOutlet private weak var applicationFooterView:UIView!
    @IBOutlet private weak var applicationBtn:UIButton!
    @IBAction private func applicationBtnAction() {
        AnalyticsEventManager.track(type: .entryJob)
        // 応募フォームに遷移
        self.pushViewController(.entryForm(routeFrom), model: _mdlJobDetail)
    }

    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        keepAction()
    }

    private var jobId = ""
    private var buttonsView: NaviButtonsView!
    private var _mdlJobDetail: MdlJobCardDetail!
    private var articleOpenFlag = false
    private var memoDispFlag = false
    private var coverageMemoOpenFlag = false
    private var selectionProcessOpenFlag = false
    private var phoneNumberOpenFlag = false
    private var companyOutlineOpenFlag = false
    private var firstOpenFlag = false
    private var articleHeaderMaxSize: CGFloat = 0
    private var articleHeaderMinSize: CGFloat = 0
    private var articleCellMaxSize: CGFloat = 0
    private var prcodesCellMaxSize: CGFloat = 0
    private var routeFrom: AnalyticsEventType.RouteFromType = .unknown

    private var keepButtonImage: UIImage {
        let keepFlag: Bool = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        return UIImage(named: keepFlag ? "btn_keep" : "btn_keepclose")!
    }
    
    var naviButtonTapActionFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        setNaviButtons()
        setup()
        changeButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getJobDetail()
        AnalyticsEventManager.track(type: .viewVacancies)
        dispKeepStatus()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let keepFlag: Bool = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        if keepFlag {
            AnalyticsEventManager.track(type: .keep)
            AnalyticsEventManager.track(type: .transitionPath(destination: .keepJob, from: routeFrom))
        }
    }

    func configure(jobId: String, routeFrom: AnalyticsEventType.RouteFromType) {
        self.jobId = jobId
        self.routeFrom = routeFrom
    }
    
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    override func initNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keepListChanged(notification:)), name: Constants.NotificationKeepStatusChanged, object: nil)
    }
    @objc func keepListChanged(notification: NSNotification) {
        //notification.userInfoにjobCardIDを入れてるので、個別の表示更新にも対応可能
        dispKeepStatus()//表示更新のため
    }
}

private extension JobOfferDetailVC {
    func setup() {
        detailTableView.backgroundColor = UIColor(colorType: .color_base)

        setKeepButton()
        registerTableViewNib()
        AnalyticsEventManager.track(type: .transitionPath(destination: .toJobDetail, from: routeFrom))
    }

    func changeButtonState() {
        keepBtn.setImage(keepButtonImage, for: .normal)
        keepBtn.setImage(keepButtonImage, for: .highlighted)
        keepBtn.setImage(keepButtonImage, for: .selected)
    }

    func setKeepButton() {
        keepBtn.imageView?.contentMode = .scaleAspectFit
        keepBtn.contentHorizontalAlignment = .fill
        keepBtn.contentVerticalAlignment = .fill
        keepBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func registerTableViewNib() {
        /// section 0
        // 終了間近,スカウト
        // 職種名
        // 給与
        // 勤務地
        // 社名
        // 掲載期限
        detailTableView.registerNib(nibName: "JobDetailDataCell", idName: "JobDetailDataCell")
        // メイン画像
        detailTableView.registerNib(nibName: "JobDetailImageCell", idName: "JobDetailImageCell")
        /// section 1
        // 記事
        detailTableView.registerNib(nibName: "JobDetailArticleCell", idName: "JobDetailArticleCell")
        /// section 2
        // PRコード
        detailTableView.registerNib(nibName: "JobDetailPRCodeTagsCell", idName: "JobDetailPRCodeTagsCell")
        // 給与例
        detailTableView.registerNib(nibName: "JobDetailSalaryExampleCell", idName: "JobDetailSalaryExampleCell")
        /// section 3
        // 募集要項
        detailTableView.registerNib(nibName: "JobDetailWorkContentsCell", idName: "JobDetailWorkContentsCell")
        detailTableView.registerNib(nibName: "JobDetailAttentionCell", idName: "JobDetailAttentionCell")
        // 1.仕事内容:              必須  3-0
        // 　・案件例:               任意
        // 　・手掛ける商品・サービス:   任意
        // 　・開発環境・業務範囲:     任意
        // 　・注目ポイント:           任意 3-1,3-2
        detailTableView.registerNib(nibName: "JobDetailItemCell", idName: "JobDetailItemCell")
        // 2.応募資格:              必須  3-3
        // 　・歓迎する経験・スキル:     任意
        // 　・過去の採用例:           任意
        // 　・この仕事の向き・不向き:  任意
        // 3.雇用携帯コード:        必須 3-4
        // 4.給与:               必須 3-5
        // 　・賞与について:          任意
        // 5.勤務時間:             必須 3-6
        //   ・残業について:
        // 6.勤務地:              必須 3-7
        //   ・交通詳細
        // 7.休日休暇:            必須 3-8
        // 8.待遇・福利厚生:       必須 3-9
        // 　・産休・育休取得:      任意
        /// section 4
        // 取材メモ
        detailTableView.registerNib(nibName: "JobDetailFoldingMemoCell", idName: "JobDetailFoldingMemoCell")
        /// section 5
        // 選考プロセス
        detailTableView.registerNib(nibName: "JobDetailFoldingProcessCell", idName: "JobDetailFoldingProcessCell")
        /// section 6
        // 連絡先
        detailTableView.registerNib(nibName: "JobDetailFoldingPhoneNumberCell", idName: "JobDetailFoldingPhoneNumberCell")
        /// section 7
        // 会社概要
        detailTableView.registerNib(nibName: "JobDetailFoldingOutlineCell", idName: "JobDetailFoldingOutlineCell")
        /// section 8
        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }

    func dispKeepStatus() {
        let keepFlag: Bool = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        changeButtonState()
    }
    
    
    func keepAction() {
        var keepFlag: Bool = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        keepFlag = !keepFlag
        changeButtonState()

        SVProgressHUD.show()
        // キープ情報送信
        if keepFlag == true {
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "keep send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                SVProgressHUD.dismiss()
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")

            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                SVProgressHUD.dismiss()
            }
        }
    }

    func setNaviButtons() {
            let titleView = UINib(nibName: "NaviButtonsView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
                .first as! NaviButtonsView
            titleView.delegate = self
            navigationItem.titleView = titleView
            buttonsView = titleView
        }

        // メイン記事タイトルサイズ
        func makeArticleHeaderSize() {
            articleHeaderMinSize = 80

            let spaceW:CGFloat = 15
            let width = detailTableView.frame.size.width - (spaceW * 2)
            let label:UILabel = UILabel()
            let text = _mdlJobDetail.mainTitle

            label.text(text: text, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            label.numberOfLines = 0

            let labelSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

            articleHeaderMaxSize = (labelSize.height + 10)
        }

        // メイン記事サイズ
        func makeArticleCellSize() {
            let spaceW: CGFloat = 15
            let width = detailTableView.frame.size.width - (spaceW * 2)
            let label: UILabel = UILabel()
            let text = self._mdlJobDetail.mainContents

            label.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            label.numberOfLines = 0

            let labelSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

            articleCellMaxSize = (labelSize.height + 40)
        }

        // PRコードの表示サイズ 最大３行
        func makePrCodesCellSize() {
            let spaceW: CGFloat = 15
            let width = detailTableView.frame.size.width - (spaceW * 2)
            let label:UILabel = UILabel()
            let prCodes = _mdlJobDetail.prCodes

            var allText:String = ""

            for i in 0..<prCodes.count {
                let codeNo = prCodes[i]
                let prCode:String = (SelectItemsManager.getCodeDisp(.prCode, code: codeNo)?.disp) ?? ""
                let tagText = "#" + prCode
                allText += tagText
                if i < (prCode.count-1) {
                    allText += " "
                }
            }
            label.lineBreakMode = .byClipping
            label.text(text: allText, fontType: .font_SS, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            label.numberOfLines = 3

            let labelSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            prcodesCellMaxSize = (labelSize.height + 30)
        }

        // 取材メモ表示フラグ
        func memoDispFlagCheck(memo: String) -> Bool {
            return memo.count > 0
        }

        private func changeButtonEnable(_ isEnable: Bool) {
            buttonsView.isHidden = !isEnable//上部の表示切り替えは非表示にする
            applicationBtn.isEnabled = isEnable//応募ボタンを非活性にする
            keepBtn.isEnabled = isEnable//キープボタンを非活性にする
        }

        func getJobDetail() {
            SVProgressHUD.show()
            LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self._mdlJobDetail = MdlJobCardDetail()//空のモデルを設定しておく
            Log.selectLog(logLevel: .debug, "jobId:\(jobId)")
            LogManager.appendApiLog("getJobDetail", "[jobId: \(jobId)]", function: #function, line: #line)
            ApiManager.getJobDetail(jobId, isRetry: true)
            .done { result in
                self.changeButtonEnable(true)//求人詳細に対するUI操作を可能にする
                LogManager.appendApiResultLog("getJobDetail", result, function: #function, line: #line)
                debugLog("ApiManager getJobDetail result:\(result.debugDisp)")
                self._mdlJobDetail = result//取得成功したら、そのモデルで更新する
                Log.selectLog(logLevel: .debug, "_mdlJobDetail.jobCardCode:\(self._mdlJobDetail.jobCardCode)")

                self.makeArticleHeaderSize()
                self.makeArticleCellSize()

                self.makePrCodesCellSize()
            }
            .catch { (error) in
                self.changeButtonEnable(false)//求人詳細に対するUI操作を不可能にする
                LogManager.appendApiErrorLog("getJobDetail", error, function: #function, line: #line)
                Log.selectLog(logLevel: .debug, "error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                Log.selectLog(logLevel: .debug, "myErr:\(myErr.debugDisp)")
                //===取得できなかった場合、リトライさせるか、前の画面に戻るかする（ディープリンクで遷移してきた場合にも対応させるため）
                switch myErr.code {
                case 404, 410:
                    let title: String = ""
                    let message: String = "現在掲載されていない求人です"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let backAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(backAction)
                    self.present(alert, animated: true, completion: nil)
                default:
                    let title: String = ""
                    let message: String = "正常に取得出来ません"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let backAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    let retryAction = UIAlertAction(title: "リトライ", style: .default) { (action:UIAlertAction) in
                        self.getJobDetail()
                    }
                    alert.addAction(backAction)
                    alert.addAction(retryAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            .finally {
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                self.recommendAction()//詳細表示をしようとしたのでリコメンド叩く（エラー出てても叩いて良い）
                self.tableViewSettingAction()
                self.dispKeepStatus()
            }
        }

        // データがセットされた後にtableViewの表示を開始
        func tableViewSettingAction() {
            if _mdlJobDetail != nil {
                memoDispFlag = self.memoDispFlagCheck(memo: _mdlJobDetail.interviewMemo)

                detailTableView.delegate = self
                detailTableView.dataSource = self
                detailTableView.reloadData()
            }
        }

        func recommendAction() {
            RecommendManager.fetchRecommend(type: .ap341, jobID: self.jobId)
            .done { result in
                Log.selectLog(logLevel: .debug, "求人詳細のレコメンド 成功:\(result)")
            }
            .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                Log.selectLog(logLevel: .debug, "求人詳細のレコメンド エラー:\(myErr.debugDisp)")
            }
            .finally {
            }
        }
}

extension JobOfferDetailVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                return UITableView.automaticDimension
            case (0,1):
                return UITableView.automaticDimension
            case (1,0):
//                return articleOpenFlag ? articleCellMaxSize : 0
                return articleOpenFlag ? UITableView.automaticDimension : 0
            case (2,0):
                return prcodesCellMaxSize
            case (3,1):
                let spotTitle1 = _mdlJobDetail.spotTitle1
                let spotDetail1 = _mdlJobDetail.spotDetail1
                if (spotTitle1.count > 0 && spotDetail1.count > 0) {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (3,2):
                let spotTitle2 = _mdlJobDetail.spotTitle2
                let spotDetail2 = _mdlJobDetail.spotDetail2
                if (spotTitle2.count > 0 && spotDetail2.count > 0) {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (3,3):
                let type = _mdlJobDetail.employmentType
//                Log.selectLog(logLevel: .debug, "_mdlJobDetail.employmentType:\(_mdlJobDetail.employmentType)")
                if type.count > 0 {
//                let employmentType = SelectItemsManager.getCodeDisp(.employmentType, code: type)?.disp ?? ""
//                if employmentType.count > 0 {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (4,0):
                return coverageMemoOpenFlag ? UITableView.automaticDimension : 0
            case (5,0):
                return selectionProcessOpenFlag ? UITableView.automaticDimension : 0
            case (6,0):
                return phoneNumberOpenFlag ? UITableView.automaticDimension : 0
            case (7,0):
                return companyOutlineOpenFlag ? UITableView.automaticDimension : 0
            default:
                return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight:CGFloat = 0
        switch section {
            case 1:
                headerHeight = articleOpenFlag ? articleHeaderMaxSize : articleHeaderMinSize
            case 3:
                headerHeight = 60
            case 4:
                headerHeight = memoDispFlag ? 50 : 0
            case 5,6,7:
                headerHeight = 55
            default:
                headerHeight = 0
        }
        tableView.sectionHeaderHeight = headerHeight
        return headerHeight
    }
}

extension JobOfferDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 7:
            return 35
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
            case 7:
                let view = UIView()
                view.backgroundColor = UIColor.init(colorType: .color_base)
                return view
            default:
                return UIView()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 1:
                // メイン記事タイトル
                let view = UINib(nibName: "JobDetailArticleHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailArticleHeaderView
                view.delegate = self
                let articleTitle = _mdlJobDetail.mainTitle
                view.setup(string: articleTitle,openFlag: articleOpenFlag)
                return view
            case 3:
                // 募集要項
                let view = UINib(nibName: "JobDetailGuideBookHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailGuideBookHeaderView
                return view
            case 4,5,6,7:
                var dispFlag:Bool = false
                switch section {
                    case 4:
                        dispFlag = memoDispFlag
                    case 5:
                        dispFlag = true
                    case 6:
                        dispFlag = true
                    case 7:
                        dispFlag = true
                    default:
                        dispFlag = false
                }
                if dispFlag == false {
                    return nil
                }
                // 取材メモ
                // 選考プロセス
                // 連絡先
                // 会社概要
                let view = UINib(nibName: "JobDetailFoldingHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailFoldingHeaderView
                view.delegate = self
                view.tag = (section - 4)

                view.topLineView.isHidden = false

                var openFlag:Bool = false
                var title:String = ""
                switch section {
                    case 4:
                    view.topLineView.isHidden = true
                        openFlag = coverageMemoOpenFlag
                        title = "取材メモ"
                    case 5:
                        openFlag = selectionProcessOpenFlag
                        title = "選考プロセス"
                    case 6:
                        openFlag = phoneNumberOpenFlag
                        title = "連絡先"
                    case 7:
                        openFlag = companyOutlineOpenFlag
                        title = "会社概要"
                    default:
                        openFlag = false
                        title = ""
                }
                view.setup(title: title,openFlag: openFlag)

                return view
            default:
                return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //モデル取得できていなければ0にしておく
        if self._mdlJobDetail.jobCardCode.isEmpty { return 0 }//フェッチ失敗していた場合など、jobCardCodeが空になっているので
        return 8
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 2:
                if _mdlJobDetail.salarySample.count > 0 {
                    return 2
                } else {
                    return 1
                }
            case 3:
                return 10
            default:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
//        Log.selectLog(logLevel: .debug, "section:\(section),row:\(row)")
        switch (section,row) {
            case (0,0):
                // 求人内容
                let cell = tableView.loadCell(cellName: "JobDetailDataCell", indexPath: indexPath) as! JobDetailDataCell
                cell.setup(data: _mdlJobDetail)
                return cell
            case (0,1):
                // 求人画像
                let cell = tableView.loadCell(cellName: "JobDetailImageCell", indexPath: indexPath) as! JobDetailImageCell

                cell.setCellWidth(width: self.detailTableView.frame.size.width)
                cell.setup(data: _mdlJobDetail)
                return cell
            case (1,0):
                // メイン記事の展開処理
                if articleOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailArticleCell", indexPath: indexPath) as! JobDetailArticleCell
                    cell.delegate = self
                    if articleOpenFlag {
                        let articleString = _mdlJobDetail.mainContents
                        cell.setup(data: articleString)
                    } else {
                        cell.setup(data: "")
                    }
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (2,0):
                // 求人PRコード
                let cell = tableView.loadCell(cellName: "JobDetailPRCodeTagsCell", indexPath: indexPath) as! JobDetailPRCodeTagsCell
                let datas = _mdlJobDetail.prCodes
                cell.setup(prcodeNos: datas)
                return cell
            case (2,1):
                // 給与サンプル
                let cell = tableView.loadCell(cellName: "JobDetailSalaryExampleCell", indexPath: indexPath) as! JobDetailSalaryExampleCell
                let examples = _mdlJobDetail.salarySample
                cell.setup(data: examples)
                return cell
            case (3,0):
                // 仕事内容
                let cell = tableView.loadCell(cellName: "JobDetailWorkContentsCell", indexPath: indexPath) as! JobDetailWorkContentsCell
                cell.setup(data: _mdlJobDetail)
                return cell
            case (3,1):
                // 注目1
                let spotTitle1 = _mdlJobDetail.spotTitle1
                let spotDetail1 = _mdlJobDetail.spotDetail1
                let spotTitle2 = _mdlJobDetail.spotTitle2
                let spotDetail2 = _mdlJobDetail.spotDetail2
                if (spotTitle1.count > 0 && spotDetail1.count > 0) {
                    var flag = false
                    if (spotTitle2.count == 0 || spotDetail2.count == 0) {
                        flag = true
                    }
//                    Log.selectLog(logLevel: .debug, "注目１セル表示")
                    let cell = tableView.loadCell(cellName: "JobDetailAttentionCell", indexPath: indexPath) as! JobDetailAttentionCell
                    cell.setup(title: spotTitle1, text: spotDetail1, bottomSpaceFlag: flag)
                    return cell
                } else {
//                    Log.selectLog(logLevel: .debug, "注目１セル非表示")
                    return UITableViewCell()
                }
            case (3,2):
                // 注目2
                let spotTitle2 = _mdlJobDetail.spotTitle2
                let spotDetail2 = _mdlJobDetail.spotDetail2
                if (spotTitle2.count > 0 && spotDetail2.count > 0) {
//                    Log.selectLog(logLevel: .debug, "注目２セル表示")
                    let cell = tableView.loadCell(cellName: "JobDetailAttentionCell", indexPath: indexPath) as! JobDetailAttentionCell
                    cell.setup(title: spotTitle2, text: spotDetail2, bottomSpaceFlag: true)
                    return cell
                } else {
//                    Log.selectLog(logLevel: .debug, "注目２セル非表示")
                    return UITableViewCell()
                }
            case (3,3):
                // 雇用形態
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                let type = _mdlJobDetail.employmentType
                if type.count > 0 {
//                let employmentType = SelectItemsManager.getCodeDisp(.employmentType, code: type)?.disp ?? ""
//                if employmentType.count > 0 {
                    cell.setup(data: _mdlJobDetail, indexPath: indexPath)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (3,_):
                // 仕事内容
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                cell.setup(data: _mdlJobDetail, indexPath: indexPath)
                return cell
            case (4,_): // メモ
                if coverageMemoOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingMemoCell", indexPath: indexPath) as! JobDetailFoldingMemoCell

                    let memoData = _mdlJobDetail.interviewMemo
                    cell.setup(data: memoData)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (5, _):    // プロセス
                if selectionProcessOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingProcessCell", indexPath: indexPath) as! JobDetailFoldingProcessCell

                    let process = _mdlJobDetail.selectionProcess
                    cell.setup(data: process)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (6, _):
                // 連絡先
                if phoneNumberOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingPhoneNumberCell", indexPath: indexPath) as! JobDetailFoldingPhoneNumberCell

                    let data = _mdlJobDetail.contactInfo
                    cell.setup(data: data)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (7, _):    // 会社概要
                if companyOutlineOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingOutlineCell", indexPath: indexPath) as! JobDetailFoldingOutlineCell

                    let data = _mdlJobDetail.companyDescription
                    cell.setup(data: data)
                    return cell
                } else {
                    return UITableViewCell()
                }
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.init(colorType: .color_base)
                return cell
        }
    }

}

extension JobOfferDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        // ヘッダーの位置調整
        let sectionHeaderHeight = detailTableView.sectionHeaderHeight

        if offsetY <= sectionHeaderHeight && offsetY >= 0.0 {
            let edgeInset = UIEdgeInsets(top: -offsetY, left: 0.0, bottom: 0.0, right: 0.0)
            scrollView.contentInset = edgeInset
        } else if offsetY >= sectionHeaderHeight {
            let edgeInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0.0, bottom: 0.0, right: 0.0)
            scrollView.contentInset = edgeInset
        }
    }
}

extension JobOfferDetailVC: NaviButtonsViewDelegate {
    func workContentsAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        buttonsView.colorChange(no:0)

        let section = 3
        let row = 0
        let titleName = "仕事内容"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    func appImportantAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        buttonsView.colorChange(no:1)

        let section = 3
        let row = 3
        let titleName = "応募資格"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    func employeeAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        buttonsView.colorChange(no:2)

        let section = 3
        let row = 9
        let titleName = "待遇"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    // 募集要項の移動
    func guidebookScrollAnimation(section: Int,row: Int,titleName: String) {
        Log.selectLog(logLevel: .debug, "guidebookScrollAnimation start")

        let indexPath = IndexPath.init(row: row, section: section)
        detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        naviButtonTapActionFlag = false
    }

    // 企業情報,会社情報を表示
    func informationAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        buttonsView.colorChange(no:3)
        companyOutlineOpenFlag = true

        let indexPath = IndexPath.init(row: 0, section: 7)
        let indexSet = IndexSet(arrayLiteral: 7)
        self.detailTableView.reloadSections(indexSet, with: .top)
        self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        self.naviButtonTapActionFlag = false

    }


}

// 職種のオープン
extension JobOfferDetailVC: JobDetailArticleHeaderViewDelegate {
    func articleHeaderAction() {
        self.articleOpenFlag = true
        let index = IndexSet(arrayLiteral: 1)
        self.detailTableView.reloadSections(index, with: .automatic)
    }
}

// 職種のクローズ
extension JobOfferDetailVC: JobDetailArticleCellDelegate {
    func articleCellCloseAction() {
        self.articleOpenFlag = false
        let index = IndexSet(arrayLiteral: 1)
        self.detailTableView.reloadSections(index, with: .automatic)
    }

}

// 折りたたみヘッダー
extension JobOfferDetailVC: FoldingHeaderViewDelegate {
    func foldOpenCloseAction(tag: Int) {
        let section = 4 + tag
        let index = IndexSet(arrayLiteral: section)
        let _allIndex = IndexSet(arrayLiteral: 4,5,6,7)
        switch tag {
        case 0:
            coverageMemoOpenFlag = !coverageMemoOpenFlag
        case 1:
            selectionProcessOpenFlag = !selectionProcessOpenFlag
        case 2:
            phoneNumberOpenFlag = !phoneNumberOpenFlag
        case 3:
            companyOutlineOpenFlag = !companyOutlineOpenFlag
        default:
            break
        }

//        self.detailTableView.reloadSections(indexes, with: .automatic)
        if firstOpenFlag == false {
            firstOpenFlag = true
            self.detailTableView.reloadSections(_allIndex, with: .automatic)
        } else {
            self.detailTableView.reloadSections(index, with: .automatic)
        }
    }
}

extension JobOfferDetailVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
    
    private func checkListData(listDatas:[[String:Any]], savedData:[String:Any]) -> [[String:Any]] {
        
        var checkListDatas = listDatas
        
        var addFlagCnt:Int = 0
        for i in 0..<listDatas.count {
            var listData = listDatas[i]
            let listDataId = listData["jobId"] as! String
            
            let savedId = savedData["jobId"] as! String
            let savedStatus = savedData["keepStatus"] as! Bool
            
            if listDataId == savedId {
                listData["keepStatus"] = savedStatus
                checkListDatas[i] = listData
                addFlagCnt += 1
            } else {
                continue
            }
            
        }
        
        if addFlagCnt == 0 {
            checkListDatas.append(savedData)
        }
        
        
        return checkListDatas
    }
}
