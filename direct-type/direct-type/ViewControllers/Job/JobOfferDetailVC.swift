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
    
    var jobId:String = ""
    var buttonsView:NaviButtonsView!
    
    var _mdlJobDetail:MdlJobCardDetail!
    /*
    var _mdlJobDetail:MdlJobCardDetail! = MdlJobCardDetail.init(
        jobCardCode: "1",
        jobName: "SE/RPAやAI,loT関連案件など",
        salaryMinId: 10,
        salaryMaxId: 14,
        isSalaryDisplay: true,
        salaryOffer: "",
        workPlaceCodes: [10,20,30,40],
        companyName: "株式会社キャリアデザインITパートナーズ「type IT派遣」※(株)キャリアデザインセンター100%出費",
        displayPeriod: JobCardDetailDisplayPeriod.init(startAt: "20200525", endAt: "20200601"),
        mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
        subPictures: ["https://type.jp/s/campaign83/img/pc/top.png","https://type.jp/s/campaign83/img/scout.png","https://woman-type.jp/s/renewal/pc/img/top/191105_u29.png",""],
        mainTitle: "RPA,AI,loT関連プロジェクトや、大手メーカのーのR&D・・・\nこれから成長する若手こそ、案件にこだわろう。",
        mainContents: "◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n",
        prCodes: [1,3,5,7,9],
        salarySample: "■２５歳サブリーダー／年収４００万円\n■２８歳PL／年収４８０万円\n■３０歳PM／年収５５０万円\n■３２歳PM／年収５８０万円\n■３５歳PM／年収６５０万円\n■４０歳マネージャー／年収７４０万円\n■４５歳部長／年収８００万円\n",
        recruitmentReason: "",
        jobDescription: "多種多様なプロジェクトの中から、あなたの経験や希望に応じた案件で活躍していただきます。\n",
        jobExample: "【RPA案件】\n●大手不動産会社:データ入力の自動化\n●メガバンク:生産業務の自動化\nなど",
        product: "【大手不動産会社:仲介業務を支える期間システム,WEBシステム,物件管理ステム開発】\n◆\n◆\n",
        scope: "【SI案件】\n●\n◆\n◆\n●\n◆\n◆\n",
        spotTitle1: "希望を吸い上げる風土だから、理想のキャリアパスを描きやすい",
        spotDetail1: "当社では、基本的にユニット（チーム体制）でのプロジェクト配属になっており、四半期に1回面談を実施し、ユニット長がここの希望を吸い上げいます。",
        spotTitle2: "明確な評価制度【充実のインセンティブ/若手も大幅昇給可能】",
        spotDetail2: "評価を行うのは、ここの頑張りや実力を一番近くで目にしているユニット長なので、納得感のある評価を得られます。",
        qualification: "◆学歴不問\n◆なんらかの開発経験のある方\n\n",
        betterSkill: "",
        applicationExample: "多彩な経験を持った、幅広い年齢層の方が当社に入社し、活躍しています。\n",
        suitableUnsuitable: "向いている人\n新しいことにチャレンジしながら、理想のキャリアパスを実現したい方には向いてます。\n向いてない人\n現状維持を望む方や、意欲が乏しい方には、合わないかもしれません。",
        employmentType: 1,
        salary: "★前職給与保証／想定月収３３万円〜６２万円\n\n年棒４００万円〜７５０万円（１２分割で支給）＋各種手当＋インセンティブ",
        bonusAbout: "ここにテキストを表示",
        jobtime: "09:00~18:00(実動８時間)",
        overtimeCode: 2,
        overtimeAbout:  "月の平均残業時間は10～20時間程度です。\n1日に換算すると1日30分～１時間程度になります。\n当社は働き方改革が叫ばれる以前から残業を抑える取り組みをしており、\n労務上の観点から20時間以内になるように指示しています。\nその結果、20時以降社内に残る社員はほどんどいません。",
        workPlace: "★東京本社または株式会社DigiITへの出向、福岡本社勤務\n（首都圏のお客様先での常駐案件もあり）",
        transport: "・つくばエクスプレス「秋葉原駅」より徒歩1分\n・\n・\n",
        holiday: "☆年間休日124日☆\n\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n",
        welfare: "◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n",
        childcare: "ここにテキストを入れる\nここにテキストを入れる\nここにテキストを入れる\nここにテキストを入れる\n",
        interviewMemo: JobCardDetailInterviewMemo.init(interviewContent: "ここにテキストを入れる\n\nここにテキストを入れる", interviewPhoto1: "https://cdc.type.jp/images/site_type.gif", interviewPhoto2: "https://cdc.type.jp/images/site_woman.jpg", interviewPhoto3: "https://cdc.type.jp/images/service_site.png"),
        selectionProcess: JobCardDetailSelectionProcess.init(selectionProcess1: "Web応募による書類選考", selectionProcess2: "面談（１〜２回）※面談は１回のケースが多いですが、場合によって２回になる可能性もあります。", selectionProcess3: "内定", selectionProcess4: "Web応募による書類選考", selectionProcess5: "Web応募による書類選考", selectionProcessDetail: "【type】の専用応募フォームからご応募ください。\n※ご応募については秘密厳守いたします。\n※\n※\n\n----------------------------\n当求人案件は株式会社キャリアデザインセンターが運営する株式会社システムソフト type採用事務局にて応募の受付業務を代行しております。"),
        contactInfo: JobCardDetailContactInfo.init(companyUrl: "http://www.systemsoft.co.jp/", contactZipcode: "100-0004", contactAddress: "東京都千代田区大手町二丁目６番１号 朝日生命大手町ビル２階", contactPhone: "03-6261-4536", contactPerson: "採用担当", contactMail: "saiyo@systemsoft.co.jp"),
        
        companyDescription: JobCardDetailCompanyDescription.init(
            enterpriseContents: "■WEBアプリの企画・開発・導入支援\n■スマホ・タブレットアプリの企画・開発・導入支援\n■システムコンサルテーション事業\n■ソフトウェアパッケージの開発・販売・導入支援\n■サーバ・ネットワーク設計・構築・運用管理サービスの提供\n■アウトソーシング\n",
            mainCustomer: "青葉出版(株)\n(株)オープンハウス・ディベロップメント\n(株)CSEビジテック\n(株)\n(株)\n(株)",
            mediaCoverage: "明治大学博物館\nユニバーサルコンピューター(株)",
            established: "1996年12月",
            employeesCount: JobCardDetailCompanyDescriptionEmployeesCount.init(count: "132名(技術者118名)", averageAge: "３２歳", genderRatio: "5/5", middleEnter: "約５割"),
            capital: "20,000,000円",
            turnover: "14億円(2018年11月実績)",
            presidentData: JobCardDetailCompanyDescriptionPresidentData.init(presidentName: "代表取締役社長　峯岸 正積", presidentHistory: "1979年11月5日生まれ。2002年コニカミノルタ株式会社に入社。")),
        userFilter: UserFilterInfo.init(tudKeepStatus: false, tudSkipStatus: false))
    */
    
    var articleOpenFlag:Bool = false
    var memoDispFlag:Bool = false
    var coverageMemoOpenFlag:Bool = false
    var selectionProcessOpenFlag:Bool = false
    var phoneNumberOpenFlag:Bool = false
    var companyOutlineOpenFlag:Bool = false

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
        self.detailTableView.registerNib(nibName: "JobDetailFooterApplicationCell", idName: "JobDetailFooterApplicationCell")
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
            Log.selectLog(logLevel: .debug, "成功:\(result)")
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            Log.selectLog(logLevel: .debug, "エラー:\(myErr.debugDisp)")
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
//                return 253
            case (0,1):
                return 290
            case (1,0):
                return articleOpenFlag ? UITableView.automaticDimension : 0
            case (4,0):
                return coverageMemoOpenFlag ? UITableView.automaticDimension : 0
            case (5,0):
                return selectionProcessOpenFlag ? UITableView.automaticDimension : 0
            case (6,0):
                return phoneNumberOpenFlag ? UITableView.automaticDimension : 0
            case (7,0):
                return companyOutlineOpenFlag ? UITableView.automaticDimension : 0
            case (8,0):
                return 120
            default:
                return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight:CGFloat = 0
        switch section {
            case 1:
                headerHeight = articleOpenFlag ? 120 : 60
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
                
                var openFlag:Bool = false
                var title:String = ""
                switch section {
                    case 4:
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
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 2:
                return 2
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
                let cell = tableView.loadCell(cellName: "JobDetailImageCell", indexPath: indexPath) as! JobDetailImageCell
                cell.setCellWidth(width: self.detailTableView.frame.size.width)
                cell.setup(data: _mdlJobDetail)
                return cell
            case (1,0):
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
                let cell = tableView.loadCell(cellName: "JobDetailPRCodeTagsCell", indexPath: indexPath) as! JobDetailPRCodeTagsCell
                let datas = _mdlJobDetail.prCodes
//                let datas = dummyData["tags"] as! [String]
                cell.setup(prcodeNos: datas)
                return cell
            case (2,1):
                let cell = tableView.loadCell(cellName: "JobDetailSalaryExampleCell", indexPath: indexPath) as! JobDetailSalaryExampleCell
                let examples = _mdlJobDetail.salarySample
//                let examples = dummyData["salary_example"] as! String
                cell.setup(data: examples)
                return cell
            case (3,_):
//                let guideBookData = dummyData["guidebook"] as! [[String:Any]]
//                let itemData = guideBookData[row]
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                cell.setup(data: _mdlJobDetail,row:row)
//                cell.setup(data: itemData)
                return cell
            case (4,_):
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
            case (5, _):
                if selectionProcessOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingProcessCell", indexPath: indexPath) as! JobDetailFoldingProcessCell
                    
                    let process = _mdlJobDetail.selectionProcess
                    cell.setup(data: process)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (6, _):
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
            case (8, _):
                let cell = tableView.loadCell(cellName: "JobDetailFooterApplicationCell", indexPath: indexPath) as! JobDetailFooterApplicationCell
                cell.delegate = self
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
        self.detailTableView.reloadSections(index, with: .automatic)
    }
}

extension JobOfferDetailVC: JobDetailFooterApplicationCellDelegate {
    
    func footerApplicationBtnAction() {
        // TODO:応募フォームに遷移
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
