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

class JobOfferDetailVC: TmpBasicVC {
    
    @IBOutlet weak var detailTableView:UITableView!
    
    @IBOutlet weak var applicationFooterView:UIView!
    
    @IBOutlet weak var applicationBtn:UIButton!
    @IBAction func applicationBtnAction() {
        // 応募フォームに遷移
        self.pushViewController(.entryVC, model: _mdlJobDetail)
    }
    
    var keepFlag:Bool!
    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        keepFlag = !keepFlag
        
        // キープ情報送信
        if keepFlag == true {
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        }
        
        self.keepDataSetting(flag: keepFlag)
    }
    
    var jobId:String = ""
    var buttonsView:NaviButtonsView!
    
    var _mdlJobDetail:MdlJobCardDetail!
    
    var articleOpenFlag:Bool = false
    var memoDispFlag:Bool = false
    var coverageMemoOpenFlag:Bool = false
    var selectionProcessOpenFlag:Bool = false
    var phoneNumberOpenFlag:Bool = false
    var companyOutlineOpenFlag:Bool = false
    
    var firstOpenFlag:Bool = false
    
    var articleHeaderMaxSize:CGFloat = 0
    var articleHeaderMinSize:CGFloat = 0
    
    var articleCellMaxSize:CGFloat = 0
    
    var prcodesCellMaxSize:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNaviButtons()
        
        self.detailTableView.backgroundColor = UIColor.init(colorType: .color_base)
        
        /// section 0
        // 終了間近,スカウト
        // 職種名
        // 給与
        // 勤務地
        // 社名
        // 掲載期限
        self.detailTableView.registerNib(nibName: "JobDetailDataCell", idName: "JobDetailDataCell")
        // メイン画像
        self.detailTableView.registerNib(nibName: "JobDetailImageCell", idName: "JobDetailImageCell")
        /// section 1
        // 記事
        self.detailTableView.registerNib(nibName: "JobDetailArticleCell", idName: "JobDetailArticleCell")
        /// section 2
        // PRコード
        self.detailTableView.registerNib(nibName: "JobDetailPRCodeTagsCell", idName: "JobDetailPRCodeTagsCell")
        // 給与例
        self.detailTableView.registerNib(nibName: "JobDetailSalaryExampleCell", idName: "JobDetailSalaryExampleCell")
        /// section 3
        // 募集要項
        self.detailTableView.registerNib(nibName: "JobDetailItemCell", idName: "JobDetailItemCell")
        // 1.仕事内容:              必須
        // 　・案件例:               任意
        // 　・手掛ける商品・サービス:   任意
        // 　・開発環境・業務範囲:     任意
        // 　・注目ポイント:           任意
        // 2.応募資格:              必須
        // 　・歓迎する経験・スキル:     任意
        // 　・過去の採用例:           任意
        // 　・この仕事の向き・不向き:  任意
        // 3.雇用携帯コード:        必須
        // 4.給与:               必須
        // 　・賞与について:          任意
        // 5.勤務時間:             必須
        //   ・残業について:
        // 6.勤務地:              必須
        //   ・交通詳細
        // 7.休日休暇:            必須
        // 8.待遇・福利厚生:       必須
        // 　・産休・育休取得:      任意
        /// section 4
        // 取材メモ
        self.detailTableView.registerNib(nibName: "JobDetailFoldingMemoCell", idName: "JobDetailFoldingMemoCell")
        /// section 5
        // 選考プロセス
        self.detailTableView.registerNib(nibName: "JobDetailFoldingProcessCell", idName: "JobDetailFoldingProcessCell")
        /// section 6
        // 連絡先
        self.detailTableView.registerNib(nibName: "JobDetailFoldingPhoneNumberCell", idName: "JobDetailFoldingPhoneNumberCell")
        /// section 7
        // 会社概要
        self.detailTableView.registerNib(nibName: "JobDetailFoldingOutlineCell", idName: "JobDetailFoldingOutlineCell")
        /// section 8
        // 応募ボタン/キープのボタン
//        self.detailTableView.registerNib(nibName: "JobDetailFooterApplicationCell", idName: "JobDetailFooterApplicationCell")
        
        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
//        keepBtn.setTitle(text: "", fontType: .C_font_M, textColor: UIColor.clear, alignment: .center)
        
        keepFlag = false
        self.keepDataSetting(flag: keepFlag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getJobDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setNaviButtons() {
        
        let titleView = UINib(nibName: "NaviButtonsView", bundle: nil)
        .instantiate(withOwner: nil, options: nil)
            .first as! NaviButtonsView
        
        titleView.delegate = self
        
        self.navigationItem.titleView = titleView
        
        buttonsView = titleView
    }
    
    // メイン記事タイトルサイズ
    private func makeArticleHeaderSize() {
        articleHeaderMinSize = 80
        
        let spaceW:CGFloat = 15
        let width = self.detailTableView.frame.size.width - (spaceW * 2)
        let label:UILabel = UILabel()
        
        let text = self._mdlJobDetail.mainTitle
        label.text(text: text, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        label.numberOfLines = 0
        
        let labelSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        articleHeaderMaxSize = (labelSize.height + 10)
    }
    
    // メイン記事サイズ
    private func makeArticleCellSize() {
        
        let spaceW:CGFloat = 15
        let width = self.detailTableView.frame.size.width - (spaceW * 2)
        let label:UILabel = UILabel()
        
        let text = self._mdlJobDetail.mainContents
        label.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        label.numberOfLines = 0
        
        let labelSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        articleCellMaxSize = (labelSize.height + 40)
    }
    
    // PRコードの表示サイズ 最大３行
    private func makePrCodesCellSize() {
        
        let spaceW:CGFloat = 15
        let width = self.detailTableView.frame.size.width - (spaceW * 2)
        let label:UILabel = UILabel()
        
        let prCodes = self._mdlJobDetail.prCodes
        
        var allText:String = ""
//        for i in 0..<dummyDatas.count {
        for i in 0..<prCodes.count {
            let codeNo = prCodes[i]
            let prCode:String = (SelectItemsManager.getCodeDisp(.prCode, code: codeNo)?.disp) ?? ""
//            let prCode:String = dummyDatas[i]
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
//        Log.selectLog(logLevel: .debug, "labelSize:\(labelSize)")
        prcodesCellMaxSize = (labelSize.height + 30)
    }
    
    // 取材メモ表示フラグ
    private func memoDispFlagCheck(memo: String) -> Bool {
        if memo.count > 0 {
//        if memo.interviewContent.count > 0 {
            return true
        }
        return false
    }
    
    private func getJobDetail() {
        SVProgressHUD.show()
        self._mdlJobDetail = MdlJobCardDetail()
        Log.selectLog(logLevel: .debug, "jobId:\(jobId)")
        ApiManager.getJobDetail(jobId, isRetry: true)
            .done { result in
                debugLog("ApiManager getJobDetail result:\(result.debugDisp)")
                
                self._mdlJobDetail = result
                
                self.makeArticleHeaderSize()
                self.makeArticleCellSize()
                
                self.makePrCodesCellSize()
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            Log.selectLog(logLevel: .debug, "myErr:\(myErr.debugDisp)")
            self.showError(myErr)
            
            switch myErr.code {
                case 403:
                    self.showError(myErr)
                default:
                    self.showError(myErr)
            }
        }
        .finally {
            SVProgressHUD.dismiss()
            
            self.recommendAction()

            self.tableViewSettingAction()
        }
    }
    
    // データがセットされた後にtableViewの表示を開始
    private func tableViewSettingAction() {
        if _mdlJobDetail != nil {
            memoDispFlag = self.memoDispFlagCheck(memo: _mdlJobDetail.interviewMemo)

            self.detailTableView.delegate = self
            self.detailTableView.dataSource = self
            self.detailTableView.reloadData()
        }
    }
    
    private func recommendAction() {
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
    
    private func keepDataSetting(flag:Bool) {
        let imageName:String = flag ? "btn_keep" : "btn_keepclose"
        let btnImage = UIImage(named: imageName)
        keepBtn.imageView?.contentMode = .scaleAspectFit
        keepBtn.contentHorizontalAlignment = .fill
        keepBtn.contentVerticalAlignment = .fill
        keepBtn.setImage(btnImage, for: .normal)
        keepBtn.setImage(btnImage, for: .highlighted)
        keepBtn.setImage(btnImage, for: .selected)
        keepBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension JobOfferDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                return UITableView.automaticDimension
//                return 253
            case (0,1):
//                return 290
                return UITableView.automaticDimension
            case (1,0):
                return articleOpenFlag ? articleCellMaxSize : 0
            case (2,0):
                return prcodesCellMaxSize
            case (4,0):
                return coverageMemoOpenFlag ? UITableView.automaticDimension : 0
            case (5,0):
                return selectionProcessOpenFlag ? UITableView.automaticDimension : 0
            case (6,0):
                return phoneNumberOpenFlag ? UITableView.automaticDimension : 0
            case (7,0):
                return companyOutlineOpenFlag ? UITableView.automaticDimension : 0
//            case (8,0):
//                return 120
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
//        return 9
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
                return 8
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
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
                //
                if articleOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailArticleCell", indexPath: indexPath) as! JobDetailArticleCell
                    cell.delegate = self
                    if articleOpenFlag {
                        let articleString = _mdlJobDetail.mainContents
//                        let articleString = dummyData["main_article"] as! String
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
//                let datas = dummyData["tags"] as! [String]
                cell.setup(prcodeNos: datas)
                return cell
            case (2,1):
                // 給与サンプル
                let cell = tableView.loadCell(cellName: "JobDetailSalaryExampleCell", indexPath: indexPath) as! JobDetailSalaryExampleCell
                let examples = _mdlJobDetail.salarySample
//                let examples = dummyData["salary_example"] as! String
                cell.setup(data: examples)
                return cell
            case (3,_):
                // 仕事内容
//                let guideBookData = dummyData["guidebook"] as! [[String:Any]]
//                let itemData = guideBookData[row]
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                cell.setup(data: _mdlJobDetail,row:row)
//                cell.setup(data: itemData)
                return cell
            case (4,_): // メモ
                if coverageMemoOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingMemoCell", indexPath: indexPath) as! JobDetailFoldingMemoCell
                    
                    let memoData = _mdlJobDetail.interviewMemo
                    cell.setup(data: memoData)
//                    cell.setup(data: memoData)
//                    let foldingDatas = dummyData["folding"] as! [String: Any]
//                    let foldingData = foldingDatas["memo"] as! [String: Any]
//                    let memoText = foldingData["text"] as! String
//                    cell.setup(data: memoText)
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
            /*
            case (8, _):
                let cell = tableView.loadCell(cellName: "JobDetailFooterApplicationCell", indexPath: indexPath) as! JobDetailFooterApplicationCell
                cell.delegate = self
                return cell
            */
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
        let sectionHeaderHeight = self.detailTableView.sectionHeaderHeight                          // ヘッダーの高さ
        
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
        buttonsView.colorChange(no:0)
        
        let section = 3
        let row = 0
        let titleName = "仕事内容"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }
    
    func appImportantAction() {
        buttonsView.colorChange(no:1)
        
        let section = 3
        let row = 1
        let titleName = "応募資格"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }
    
    func employeeAction() {
        buttonsView.colorChange(no:2)
        
        let section = 3
        let row = 7
        let titleName = "待遇"
        self.guidebookScrollAnimation(section: section,row: row, titleName: titleName)
    }
    
    func informationAction() {
        buttonsView.colorChange(no:3)
        
//        let section = 3
//        let titleName = "企業情報"
//        self.guidebookScrollAnimation(section: section,titleName: titleName)
        
        companyOutlineOpenFlag = true
        let indexPath = IndexPath.init(row: 0, section: 7)
        let indexSet = IndexSet(arrayLiteral: 7)
        self.detailTableView.reloadSections(indexSet, with: .top)
        self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // 募集要項の移動
    func guidebookScrollAnimation(section: Int,row: Int,titleName: String) {
        Log.selectLog(logLevel: .debug, "guidebookScrollAnimation start")
        
        let indexPath = IndexPath.init(row: row, section: section)
        self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
//        let foldingDatas = dummyData["folding"] as! [String: Any]
        
//        let section = foldingDatas.count + tag
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

// TODO:仕様変わりを考えて残しておく。
/*
extension JobOfferDetailVC: JobDetailFooterApplicationCellDelegate {
    
    func footerApplicationBtnAction() {
        //応募フォームに遷移
        self.pushViewController(.entryVC, model: _mdlJobDetail)
    }
    
    func footerKeepBtnAction(keepStatus: Bool) {
        // キープ情報送信
        if keepStatus == true {
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        }
    }
}
*/
