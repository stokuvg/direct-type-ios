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
//        if (self._mdlJobDetail.entryStatus == true) { return }
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
    var deviceType:String = ""
    
    var articleHeaderPosition:CGPoint = CGPoint.zero
    
    // 仕事内容セル
    var checkWorkContentsCell:JobDetailWorkContentsCell!
    // 応募資格セル
    var checkQualificationCell:JobDetailQualifcationCell!
    // 待遇セル
    var checkTreatmentCell:JobDetailTreatmentCell!
    // 会社概要セル
    var checkOutlineHeaderCell:JobDetailFoldingHeaderCell!
    
    // 画面スクロールを手動で行なっているか、ボタンなどで行なっているか。
    var autoScrollActionFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceType = DeviceHelper.getDeviceInfo()
        
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
    
    private func updateTableOffset(animation:Bool = false) {
//        Log.selectLog(logLevel: .debug, "updateTableOffset start")
//        Log.selectLog(logLevel: .debug, "articleHeaderPosition:\(articleHeaderPosition)")
        let indexPath = IndexPath.init(row: 0, section: 1)
        UIView.animate(withDuration: 0.0, animations: {
            self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }, completion: { (finished) in
            // スクロール位置の調整終了
            UIView.animate(withDuration: 0.0, animations: {
//                Log.selectLog(logLevel: .debug, "offsetの更新")
                self.detailTableView.setContentOffset(self.articleHeaderPosition, animated: animation)
            }, completion: {(secondFinished) in
                Log.selectLog(logLevel: .debug, "detailTableViewの更新結果:\(String(describing: self.detailTableView))")
            })
        })
    }
}

private extension JobOfferDetailVC {
    func setup() {
        detailTableView.backgroundColor = UIColor(colorType: .color_base)
        detailTableView.decelerationRate = .normal

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
        // 記事ヘッダー
        detailTableView.registerNib(nibName: "JobDetailArticleHeaderCell", idName: "JobDetailArticleHeaderCell")
        // 記事
        detailTableView.registerNib(nibName: "JobDetailArticleCell", idName: "JobDetailArticleCell")
        /// section 2
        // PRコード
        detailTableView.registerNib(nibName: "JobDetailPRCodeTagsCell", idName: "JobDetailPRCodeTagsCell")
        // 給与例
        detailTableView.registerNib(nibName: "JobDetailSalaryExampleCell", idName: "JobDetailSalaryExampleCell")
        /// section 3
        // 募集要項     3-0
        detailTableView.registerNib(nibName: "JobDetailGuideBookHeaderCell", idName: "JobDetailGuideBookHeaderCell")
        // 1.仕事内容:              必須  3-1
        detailTableView.registerNib(nibName: "JobDetailWorkContentsCell", idName: "JobDetailWorkContentsCell")
        // 　・案件例:               任意
        // 　・手掛ける商品・サービス:   任意
        // 　・開発環境・業務範囲:     任意
        // 　・注目ポイント:           任意 3-2,3-3
        detailTableView.registerNib(nibName: "JobDetailAttentionCell", idName: "JobDetailAttentionCell")
        // 2.応募資格:              必須  3-4
        detailTableView.registerNib(nibName: "JobDetailQualifcationCell", idName: "JobDetailQualifcationCell")
        // 　・歓迎する経験・スキル:     任意
        // 　・過去の採用例:           任意
        // 　・この仕事の向き・不向き:  任意
        // 3.雇用携帯コード:        必須 3-5
        // 4.給与:               必須 3-6
        // 　・賞与について:          任意
        // 5.勤務時間:             必須 3-7
        //   ・残業について:
        // 6.勤務地:              必須 3-8
        //   ・交通詳細
        // 7.休日休暇:            必須 3-9
        detailTableView.registerNib(nibName: "JobDetailItemCell", idName: "JobDetailItemCell")
        // 8.待遇・福利厚生:       必須 3-10
        // 　・産休・育休取得:      任意
        detailTableView.registerNib(nibName: "JobDetailTreatmentCell", idName: "JobDetailTreatmentCell")
        /// section 4
        // ヘッダー
        detailTableView.registerNib(nibName: "JobDetailFoldingHeaderCell", idName: "JobDetailFoldingHeaderCell")
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
//        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
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
    
    private func changeEventStatus(eventStatus: Bool) {
        /*
        applicationBtn.isEnabled = !eventStatus
        if eventStatus {
            applicationBtn.setTitle(text: "応募済みです", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            applicationBtn.backgroundColor = UIColor.lightGray
            
        } else {
            applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            applicationBtn.backgroundColor = UIColor.init(colorType: .color_button)
            
        }
        */
        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        applicationBtn.backgroundColor = UIColor.init(colorType: .color_button)
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
            
//            let eventStatus = self._mdlJobDetail.entryStatus
//            Log.selectLog(logLevel: .debug, "eventStatus:\(eventStatus)")
            
            self.changeEventStatus(eventStatus:self._mdlJobDetail.entryStatus)
//            Log.selectLog(logLevel: .debug, "_mdlJobDetail.jobCardCode:\(self._mdlJobDetail.jobCardCode)")

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
    
    func returnForRowAt(indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                return UITableView.automaticDimension
            case (0,1):
                return UITableView.automaticDimension
            case (1,0):
//                Log.selectLog(logLevel: .debug, "DeviceInfo:\(DeviceHelper.getDeviceInfo())")
                return articleOpenFlag ? articleHeaderMaxSize : articleHeaderMinSize
            case (1,1):
                if articleOpenFlag {
                    let articleText = self._mdlJobDetail.mainContents
                    if articleText.count == 0 {
                        return 0
                    }
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (2,0):
                return prcodesCellMaxSize
            case (3,0):
                return 60
            case (3,2):
                let spotTitle1 = _mdlJobDetail.spotTitle1
                let spotDetail1 = _mdlJobDetail.spotDetail1
                if (spotTitle1.count > 0 && spotDetail1.count > 0) {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (3,3):
                let spotTitle2 = _mdlJobDetail.spotTitle2
                let spotDetail2 = _mdlJobDetail.spotDetail2
                if (spotTitle2.count > 0 && spotDetail2.count > 0) {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            case (3,4):
                return UITableView.automaticDimension
            case (4,0),(5,0),(6,0),(7,0):
                return 55
            case (4,1):
                return coverageMemoOpenFlag ? UITableView.automaticDimension : 0
            case (5,1):
                return selectionProcessOpenFlag ? UITableView.automaticDimension : 0
            case (6,1):
                return phoneNumberOpenFlag ? UITableView.automaticDimension : 0
            case (7,1):
                return companyOutlineOpenFlag ? UITableView.automaticDimension : 0
            default:
                return UITableView.automaticDimension
        }
    }
}

extension JobOfferDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.selectLog(logLevel: .debug, "JobOfferDetailVC didSelectRowAt start")
        let section = indexPath.section
        let row = indexPath.row
        
        Log.selectLog(logLevel: .debug, "section:\(section),row:\(row)")

        let index = IndexSet(arrayLiteral: section)
        let _allIndex = IndexSet(arrayLiteral: 4,5,6,7)
        
        switch (section,row) {
            case (4,0):
                coverageMemoOpenFlag = !coverageMemoOpenFlag
                // 取材メモ
            case (5,0):
                selectionProcessOpenFlag = !selectionProcessOpenFlag
                // 選考プロセス
            case (6,0):
                // 連絡先
                phoneNumberOpenFlag = !phoneNumberOpenFlag
            case (7,0):
                // 会社概要の展開
                companyOutlineOpenFlag = !companyOutlineOpenFlag
            default:
                break
        }
        if 4 <= section && section <= 7 {
            if firstOpenFlag == false {
                firstOpenFlag = true
                self.detailTableView.reloadSections(_allIndex, with: .automatic)
            } else {
                self.detailTableView.reloadSections(index, with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC estimatedHeightForRowAt start")
        return self.returnForRowAt(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC heightForRowAt start")
        return self.returnForRowAt(indexPath: indexPath)
    }
}

extension JobOfferDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //モデル取得できていなければ0にしておく
        if self._mdlJobDetail.jobCardCode.isEmpty { return 0 }//フェッチ失敗していた場合など、jobCardCodeが空になっているので
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            if _mdlJobDetail.salarySample.count > 0 {
                return 2
            } else {
                return 1
            }
        case 3:
            return 11
        case 4:
            let rowCount = coverageMemoOpenFlag ? 2 : 1
            return rowCount
        case 5:
            let rowCount = selectionProcessOpenFlag ? 2 : 1
            return rowCount
        case 6:
            let rowCount = phoneNumberOpenFlag ? 2 : 1
            return rowCount
        case 7:
            let rowCount = companyOutlineOpenFlag ? 2 : 1
            return rowCount
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC cellForRowAt start")
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
                let cell = tableView.loadCell(cellName: "JobDetailArticleHeaderCell", indexPath: indexPath) as! JobDetailArticleHeaderCell
                cell.delegate = self
                
                let articleTitle = _mdlJobDetail.mainTitle
                cell.setup(string: articleTitle,openFlag: articleOpenFlag)
                return cell
            case (1,1):
                // メイン記事の展開処理
                if articleOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailArticleCell", indexPath: indexPath) as! JobDetailArticleCell
                    cell.delegate = self
                    let articleString = _mdlJobDetail.mainContents
                    if articleString.count == 0 {
                        return UITableViewCell()
                    } else {
                        cell.setup(data: articleString)
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
                // 募集要項
                let cell = tableView.loadCell(cellName: "JobDetailGuideBookHeaderCell", indexPath: indexPath) as! JobDetailGuideBookHeaderCell
                return cell
            case (3,1):
                // 仕事内容
                let cell = tableView.loadCell(cellName: "JobDetailWorkContentsCell", indexPath: indexPath) as! JobDetailWorkContentsCell
                cell.setup(data: _mdlJobDetail)
                checkWorkContentsCell = cell
                return cell
            case (3,2):
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
                    let cell = UITableViewCell()
                    cell.backgroundColor = UIColor.init(colorType: .color_base)
                    return cell
                }
            case (3,3):
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
                    let cell = UITableViewCell()
                    cell.backgroundColor = UIColor.init(colorType: .color_base)
                    return cell
                }
            case (3,4):
                // 応募資格
                let cell = tableView.loadCell(cellName: "JobDetailQualifcationCell", indexPath: indexPath) as! JobDetailQualifcationCell
                let type = _mdlJobDetail.employmentType
                if type.count > 0 {
//                let employmentType = SelectItemsManager.getCodeDisp(.employmentType, code: type)?.disp ?? ""
//                if employmentType.count > 0 {
                    cell.setup(data: _mdlJobDetail)
                    checkQualificationCell = cell
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (3,10):
                // 待遇
                let cell = tableView.loadCell(cellName: "JobDetailTreatmentCell", indexPath: indexPath) as! JobDetailTreatmentCell
                cell.setup(data: _mdlJobDetail)
                checkTreatmentCell = cell
                return cell
            case (3,_):
                // 仕事内容
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                cell.setup(data: _mdlJobDetail, indexPath: indexPath)
                return cell
            case (4,0),(5,0),(6,0),(7,0):
                let cell = tableView.loadCell(cellName: "JobDetailFoldingHeaderCell", indexPath: indexPath) as! JobDetailFoldingHeaderCell
                var title:String = ""
                var openFlag:Bool = false
                cell.topLineView.isHidden = false
                switch section {
                    case 4:
                    cell.topLineView.isHidden = true
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
                cell.setup(title: title, openFlag: openFlag)
                if section == 7 {
                    checkOutlineHeaderCell = cell
                }
                return cell
            case (4,1): // メモ
                let cell = tableView.loadCell(cellName: "JobDetailFoldingMemoCell", indexPath: indexPath) as! JobDetailFoldingMemoCell
                
                let memoData = _mdlJobDetail.interviewMemo
                cell.setup(data: memoData)
                print(cell.bounds.height)
                return cell
            case (5, 1):    // プロセス
                let cell = tableView.loadCell(cellName: "JobDetailFoldingProcessCell", indexPath: indexPath) as! JobDetailFoldingProcessCell
                
                let process = _mdlJobDetail.selectionProcess
                cell.setup(data: process)
                return cell
            case (6, 1):
                // 連絡先
                let cell = tableView.loadCell(cellName: "JobDetailFoldingPhoneNumberCell", indexPath: indexPath) as! JobDetailFoldingPhoneNumberCell
                
                let data = _mdlJobDetail.contactInfo
                cell.setup(data: data)
                return cell
            case (7, 1):    // 会社概要
                let cell = tableView.loadCell(cellName: "JobDetailFoldingOutlineCell", indexPath: indexPath) as! JobDetailFoldingOutlineCell
                
                let data = _mdlJobDetail.companyDescription
                cell.setup(data: data)
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.init(colorType: .color_base)
                return cell
        }
    }
}

extension JobOfferDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewDidScroll tapActionFlag:\(self.naviButtonTapActionFlag)")
        if naviButtonTapActionFlag == true || self.autoScrollActionFlag { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewDidScroll start")
        
        self.checkButtonsViewPosition(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if naviButtonTapActionFlag == true { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewWillBeginDecelerating start")
        
        self.checkButtonsViewPosition(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if naviButtonTapActionFlag == true { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewDidEndDecelerating start")
        
        self.checkButtonsViewPosition(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if naviButtonTapActionFlag == true { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewWillBeginDragging start")
        self.autoScrollActionFlag = false
        
        self.checkButtonsViewPosition(scrollView: scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if naviButtonTapActionFlag == true { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewWillEndDragging start")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if naviButtonTapActionFlag == true { return }
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC scrollViewDidEndDragging start")
        
        self.checkButtonsViewPosition(scrollView: scrollView)
    }
    
    private func checkCellOffset(offset:CGPoint, no:Int) {
        Log.selectLog(logLevel: .debug, "JobOfferDetailVC checkCellOffset start")
        
        Log.selectLog(logLevel: .debug, "ボタンの一致:\(no)")
        buttonsView.colorChange(no: no)
        Log.selectLog(logLevel: .debug, "JobOfferDetailVC checkCellOffset end")
    }
    
    private func checkInViewCell(cell: UITableViewCell, no:Int) -> Bool {
//        Log.selectLog(logLevel: .debug, "checkInViewCell start")
        
//        Log.selectLog(logLevel: .debug, "self.detailTableView:\(String(describing: self.detailTableView))")
        
//        Log.selectLog(logLevel: .debug, "cell:\(cell)")
        
//        let cellRectInView = self.detailTableView.convert(cellRect, to: self.navigationController?.view)
        
//        Log.selectLog(logLevel: .debug, "cellRectInView:\(cellRectInView)")
//        let inViewMinY = cellRectInView.minY
//        Log.selectLog(logLevel: .debug, "inViewMinY:\(inViewMinY)")
//        let inViewMaxY = cellRectInView.maxY
//        Log.selectLog(logLevel: .debug, "inViewMaxY:\(inViewMaxY)")
        
        var checkCell = cell
        if no == 1 {
            if cell != checkQualificationCell {
                Log.selectLog(logLevel: .debug, "応募資格ではなく違うセルを見ている")
                checkCell = checkQualificationCell
            }
        } else if no == 2 {
            if cell != checkTreatmentCell {
                Log.selectLog(logLevel: .debug, "待遇ではなく違うセルを見ている")
                checkCell = checkTreatmentCell
            }
        }
        
        let cellY = checkCell.frame.origin.y
//        Log.selectLog(logLevel: .debug, "cellY:\(cellY)")
        
        let tableOffsetY = self.detailTableView.contentOffset.y
//        Log.selectLog(logLevel: .debug, "tableOffsetY:\(tableOffsetY)")
        
        
        let smallCellY = cellY * 0.97
        let bigCellY = cellY * 1.03
        // セルがテーブルのOffsetY座標より中にあるか
        if smallCellY <= tableOffsetY && tableOffsetY <= bigCellY {
            return true
        }
        
//        Log.selectLog(logLevel: .debug, "checkInViewCell end")
        return false
    }
    
    private func checkButtonsViewPosition(scrollView: UIScrollView) {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC checkButtonsViewPosition start")
        
        if checkWorkContentsCell != nil && self.checkInViewCell(cell: checkWorkContentsCell, no:0) {
//            Log.selectLog(logLevel: .debug, "画面内に仕事内容セルがある")
            buttonsView.colorChange(no: 0)
        } else if checkQualificationCell != nil && self.checkInViewCell(cell: checkQualificationCell, no:1) {
//            Log.selectLog(logLevel: .debug, "画面内に応募資格セルがある")
            buttonsView.colorChange(no: 1)
        } else if checkTreatmentCell != nil && self.checkInViewCell(cell: checkTreatmentCell, no:2) {
//           Log.selectLog(logLevel: .debug, "画面内に待遇セルがある")
            buttonsView.colorChange(no: 2)
        } else if checkOutlineHeaderCell != nil && self.checkInViewCell(cell: checkOutlineHeaderCell, no: 3) {
//            Log.selectLog(logLevel: .debug, "画面内に会社概要セルがある")
            buttonsView.colorChange(no: 3)
        }

//        Log.selectLog(logLevel: .debug, "checkButtonsViewPosition scrollView end")
    }
}

extension JobOfferDetailVC: NaviButtonsViewDelegate {
    func workContentsAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        autoScrollActionFlag = true
        buttonsView.colorChange(no:0)

        let section = 3
        let row = 1
        let titleName = "仕事内容"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    func appImportantAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        autoScrollActionFlag = true
        buttonsView.colorChange(no:1)

        let section = 3
        let row = 4
        let titleName = "応募資格"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    func employeeAction() {
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        autoScrollActionFlag = true
        buttonsView.colorChange(no:2)

        let section = 3
        let row = 10
        let titleName = "待遇"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }

    // 募集要項の移動
    func guidebookScrollAnimation(section: Int,row: Int,titleName: String) {
//        Log.selectLog(logLevel: .debug, "guidebookScrollAnimation start section:\(section) row:\(row),titleName:\(titleName)")
//        Log.selectLog(logLevel: .debug, "guidebookScrollAnimation start")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            Log.selectLog(logLevel: .debug, "guidebookScrollAnimation asyncAfter start")
            UIView.animate(withDuration: 0.0, delay: 0.1, animations: {
                let indexPath = IndexPath(row: row, section: section)
                self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }, completion: { (finished) in
//                Log.selectLog(logLevel: .debug, "guidebookScrollAnimation completion start")
                self.naviButtonTapActionFlag = false
            })
        }
    }

    // 企業情報,会社情報を表示
    func informationAction() {
//        Log.selectLog(logLevel: .debug, "informationAction start")
//        Log.selectLog(logLevel: .debug, "会社概要の展開表示")
        if naviButtonTapActionFlag == true { return }
        naviButtonTapActionFlag = true
        autoScrollActionFlag = true
        buttonsView.colorChange(no:3)
        companyOutlineOpenFlag = true

        if self.firstOpenFlag == false {
            self.firstOpenFlag = true
            let indexSet = IndexSet(arrayLiteral: 6,7)
            self.detailTableView.reloadSections(indexSet, with: .none)
        } else {
            let indexSet = IndexSet(arrayLiteral: 7)
            self.detailTableView.reloadSections(indexSet, with: .none)
        }
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.0, delay: 0.1, animations: {
            let indexPath = IndexPath.init(row: 0, section: 7)
            self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }, completion: { (finished) in
                self.naviButtonTapActionFlag = false
            })
        }
    
    }


}

// 職種のオープン
/*
extension JobOfferDetailVC: JobDetailArticleHeaderViewDelegate {
    func articleHeaderAction() {
        self.articleOpenFlag = true
        let index = IndexSet(arrayLiteral: 1)
        self.detailTableView.reloadSections(index, with: .automatic)
    }
}
*/

extension JobOfferDetailVC: JobDetailArticleHeaderCellDelegate {
    func articleHeaderAction() {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC articleHeaderAction start")
        self.articleOpenFlag = true
        
        self.articleHeaderPosition = self.detailTableView.contentOffset
        
        UIView.animate(withDuration: 0.1, animations: {
            let index = IndexSet(arrayLiteral: 1)
            self.detailTableView.reloadSections(index, with: .automatic)
        }, completion: { (finished) in
            Log.selectLog(logLevel: .debug, "articleHeaderAction articleHeaderPosition:\(self.articleHeaderPosition)")
        })
    }
}

// 職種のクローズ
extension JobOfferDetailVC: JobDetailArticleCellDelegate {
    func articleCellCloseAction() {
//        Log.selectLog(logLevel: .debug, "JobOfferDetailVC articleCellCloseAction start")

        self.articleOpenFlag = false
        let _allIndex = IndexSet(arrayLiteral: 0,1,2,3)
        let index = IndexSet(arrayLiteral: 1)

//        Log.selectLog(logLevel: .debug, "テーブルの更新開始")
        UIView.animate(withDuration: 0.0, animations: {
            if self.firstOpenFlag == false {
//                Log.selectLog(logLevel: .debug, "周りのセルを更新")
                self.firstOpenFlag = true
                self.detailTableView.reloadSections(_allIndex, with: .automatic)
            } else {
//                Log.selectLog(logLevel: .debug, "折りたたみセルのみを更新")
                self.detailTableView.reloadSections(index, with: .automatic)
            }
        }, completion: { (finished) in
//            Log.selectLog(logLevel: .debug, "テーブルの更新終了")
            
            UIView.animate(withDuration: 0.0, animations: {
//                Log.selectLog(logLevel: .debug, "テーブルのoffset セット開始:\(self.articleHeaderPosition)")
                self.updateTableOffset(animation: true)
                
            }, completion: { (finished) in
                if finished {
//                    Log.selectLog(logLevel: .debug, "テーブルのoffset セット終了 detailTableView:\(String(describing: self.detailTableView))")
                    let checkOffset = self.detailTableView.contentOffset
                    if checkOffset.y != self.articleHeaderPosition.y {
//                        Log.selectLog(logLevel: .debug, "offsetが一致しないため再度セット")
                        self.updateTableOffset()
                    }
                } else {
                    UIView.animate(withDuration: 0.0, animations: {
//                        Log.selectLog(logLevel: .debug, "テーブルのoffset 再セット開始:\(self.articleHeaderPosition)")
                        self.updateTableOffset(animation: true)
                    }, completion: { (secondFinished) in
                        Log.selectLog(logLevel: .debug, "テーブルのoffset 再セット終了 detailTableView:\(String(describing: self.detailTableView))")
                    })
                }
            })
        })
        
    }
}

// 折りたたみヘッダー
extension JobOfferDetailVC: FoldingHeaderViewDelegate {
    func foldOpenCloseAction(tag: Int) {
        Log.selectLog(logLevel: .debug, "JobOfferDetailVC foldOpenCloseAction start")
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
