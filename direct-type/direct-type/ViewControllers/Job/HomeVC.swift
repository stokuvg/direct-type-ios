//
//  HomeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import SVProgressHUD
import AppsFlyerLib

enum CardDispType:Int {
    case none   // 何も無い
    case add    // 追加
    case end    // 最後まで表示
}

enum SkipSendStatus {
    case none
    case sending
}

enum KeepSendStatus {
    case none
    case sending
}

enum LimitedType {
    case none
    case new
    case end
}

class HomeVC: TmpNaviTopVC {

    @IBOutlet weak var noCardBackView:UIView!
    @IBOutlet weak var homeTableView:UITableView!

    private var profile: MdlProfile?
    private var resume: MdlResume?
    private var shouldFetchPersonalData: Bool {
        return profile == nil || resume == nil
    }
    var pageJobCards: MdlJobCardList!   // nページを取得
    var dispJobCards: MdlJobCardList!   // 取得したページを全て表示

    var moreCnt:Int = 1
    var dispType:CardDispType = .none

    var safeAreaTop:CGFloat!

    var pageNo:Int = 1

    var defaultCellHeight:CGFloat = 520

    var skipSendStatus:SkipSendStatus = .none
    var keepSendStatus:KeepSendStatus = .none

    // おすすめ求人を更新を使用しているか true:使用ずみ,false:未使用
//    var recommendUseFlag:Bool = false
    
    var useApiListFlag:Bool = true

    // 求人追加表示フラグ
    var dataAddFlag = true
    
    var firstViewFlag:Bool = true {
        didSet {
            Log.selectLog(logLevel: .debug, "new firstViewFlag")
        }
    }
    
    var changeProfileFlag:Bool = false {
        didSet {
            Log.selectLog(logLevel: .debug, "new changeProfileFlag:\(changeProfileFlag)")
        }
    }
    
    var deviceType:String = ""
    
    // AppsFlyerのイベントトラッキング用にオンメモリでキープ求人リストを保有するプロパティ
    // キープされた求人をオンメモリ上で保有しておき、この画面が切り替わった際にイベント送信する
    var keepIdListForAppsFlyer: [String] = []
    var trackedKeepIdListForAppsFlyer: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceType = DeviceHelper.getDeviceInfo()
        Log.selectLog(logLevel: .debug, "deviceType:\(deviceType)")
        
        self.navigationController?.tabBarController?.delegate = self
        homeTableView.backgroundColor = UIColor.init(colorType: .color_base)
        homeTableView.rowHeight = UITableView.automaticDimension

        homeTableView.registerNib(nibName: "JobOfferBigCardCell", idName: "JobOfferBigCardCell")        // 求人カード
        homeTableView.registerNib(nibName: "JobOfferCardMoreCell", idName: "JobOfferCardMoreCell")      // もっと見る
        homeTableView.registerNib(nibName: "JobOfferCardReloadCell", idName: "JobOfferCardReloadCell")// 全求人カード表示/更新
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.selectLog(logLevel: .debug, "HomeVC viewWillAppear start")
        AnalyticsEventManager.track(type: .viewHome)

        if firstViewFlag {
            Log.selectLog(logLevel: .debug, "初回求人ホーム表示時のAPI取得")
            shouldFetchPersonalData ? getProfileData() : getJobData()
            firstViewFlag = false
        }
        safeAreaTop = self.view.safeAreaInsets.top

        //[Dbg]___
        if Constants.DbgAutoPushVC {
            switch Constants.DbgAutoPushVCNum {
            case 1: pushViewController(.profilePreviewH2, model: MdlProfile.dummyData())
            case 2: pushViewController(.resumePreviewH3(false))
            case 3: pushViewController(.careerPreviewC15)
            case 4: pushViewController(.smoothCareerPreviewF11)
            case 5: pushViewController(.firstInputPreviewA)
            case 6: pushViewController(.careerListC)
            case 7: pushViewController(.entryForm(.fromHome), model: MdlJobCardDetail.dummyData())
            default: break
            }
        }
        //[Dbg]^^^
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.selectLog(logLevel: .debug, "HomeVC viewDidAppear start")
        
        if firstViewFlag == false && changeProfileFlag == true {
            Log.selectLog(logLevel: .debug, "マイページ更新後の求人情報更新取得開始")
            self.getProfileData()
            
            // 一応情報を再度更新
            firstViewFlag = false
            changeProfileFlag = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trackKeepActionEvent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

    private func getJobData() {
        Log.selectLog(logLevel: .debug, "HomeVC getJobData start")
        UserDefaultsManager.isInitialDisplayedHome ? getJobRecommendList() : getJobList()
        useApiListFlag = UserDefaultsManager.isInitialDisplayedHome
//        recommendUseFlag = !UserDefaultsManager.isInitialDisplayedHome
    }

    private func dataAddAction() {
        Log.selectLog(logLevel: .debug, "HomeVC dataAddAction start")
        var _jobs:[MdlJobCard] = dispJobCards.jobCards
        for i in 0..<pageJobCards.jobCards.count {
            let addJob:MdlJobCard = pageJobCards.jobCards[i]
            _jobs.append(addJob)
        }
        dispJobCards.jobCards = _jobs
        self.homeTableView.reloadData()
    }

    private func dataCheckAction() {
        Log.selectLog(logLevel: .debug, "HomeVC dataCheckAction start")

        Log.selectLog(logLevel: .debug, "pageJobCards.jobCards:\(pageJobCards.jobCards.count)")
        // ０件時レイアウト修正用
        if (pageJobCards.jobCards.count) > 0 {
            homeTableView.isHidden = false
            dispType = .add

            self.dispJobCards = self.pageJobCards

            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            self.homeTableView.reloadData()

            let topIndex = IndexPath.init(row: 0, section: 0)
            self.homeTableView.selectRow(at: topIndex, animated: true, scrollPosition: .top)

        } else {
            dispType = .none
            let cardNoView = UINib(nibName: "NoCardView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)
                .first as! NoCardView
            var cardFrame = cardNoView.frame
            cardFrame = noCardBackView.frame
            cardNoView.frame = cardFrame
            cardNoView.delegate = self
            if let _profile = self.profile {
                cardNoView.setup(profileData: _profile)
            }
            noCardBackView.addSubview(cardNoView)

            homeTableView.isHidden = true
        }
    }
    
    /// ２回目以降求人一覧追加表示
    private func getJobRecommendAddList() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        pageNo += 1
        pageJobCards = MdlJobCardList()
        LogManager.appendApiLog("getRecommendJobs", "[pageNo: \(pageNo)]", function: #function, line: #line)
        ApiManager.getRecommendJobs(pageNo, isRetry: true)
            .done { result in
                LogManager.appendApiResultLog("getRecommendJobs", result, function: #function, line: #line)
                Log.selectLog(logLevel: .debug, "getJobRecommendAddList result:\(result.debugDisp)")
                self.pageJobCards = result
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getRecommendJobs", error, function: #function, line: #line)
            Log.selectLog(logLevel: .debug, "getJobRecommendAddList error:\(error)")

            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.dataAddFlag = false
            self.dataAddAction()
        }
    }
    
    /// 初回求人一覧追加表示
    private func getJobAddList() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        pageNo += 1
        pageJobCards = MdlJobCardList()
        LogManager.appendApiLog("getJobs", "[pageNo: \(pageNo)]]", function: #function, line: #line)
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                LogManager.appendApiResultLog("getJobs", result, function: #function, line: #line)
                Log.selectLog(logLevel: .debug, "getJobAddList result:\(result.debugDisp)")
                self.pageJobCards = result
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getJobs", error, function: #function, line: #line)
            Log.selectLog(logLevel: .debug, "getJobAddList error:\(error)")

            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.dataAddFlag = false
            self.dataAddAction()
        }
    }
    /// ２回目以降求人一覧表示
    private func getJobRecommendList() {
        Log.selectLog(logLevel: .debug, "HomeVC getJobRecommendList start")
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        pageJobCards = MdlJobCardList()
        dispJobCards = MdlJobCardList()
        pageNo = 1
        LogManager.appendApiLog("getRecommendJobs", "[pageNo: \(pageNo)]]", function: #function, line: #line)
        ApiManager.getRecommendJobs(pageNo, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getRecommendJobs", result, function: #function, line: #line)
            self.pageJobCards = result
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getRecommendJobs", error, function: #function, line: #line)
            Log.selectLog(logLevel: .debug, "getJobRecommendList error:\(error)")

            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            if self.pageJobCards.updateAt.count > 0 {
                let convUpdateDate = DateHelper.convStrYMD2Date(self.pageJobCards.updateAt)
                let updateDateString = DateHelper.mdDateString(date: convUpdateDate)

                self.linesTitle(date: updateDateString, title: "あなたにぴったりの求人")
            } else {
                let nowDateString = DateHelper.mdDateString(date: Date())
                self.linesTitle(date: nowDateString, title: "あなたにぴったりの求人")
            }
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.dataAddFlag = false
            self.dataCheckAction()

            //上部にスクロールさせる（データない時に実施するとクラッシュするため）
            // おすすめ求人を更新ボタン押下時は、一番上に来る。
            if self.dispJobCards.jobCards.count > 0 {
                let topIndex = IndexPath.init(row: 0, section: 0)
                self.homeTableView.selectRow(at: topIndex, animated: true, scrollPosition: .top)
            }
        }
    }

    
    /// 初回求人一覧表示
    private func getJobList() {
        Log.selectLog(logLevel: .debug, "HomeVC getJobList start")
        pageJobCards = MdlJobCardList()
        dispJobCards = MdlJobCardList()
        pageNo = 1
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                self.pageJobCards = result
                self.setInitialDisplayedFlag()
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "getJobList error:\(error)")

            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {

            let convUpdateDate = DateHelper.convStrYMD2Date(self.pageJobCards.updateAt)
            let updateDateString = DateHelper.mdDateString(date: convUpdateDate)

            self.linesTitle(date: updateDateString, title: "あなたにぴったりの求人")
            
            self.dataAddFlag = false
            self.dataCheckAction()
            SVProgressHUD.dismiss()
            /*
            if self.pageJobCards.jobCards.count > 0 {
                SVProgressHUD.dismiss()
                /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                /*
                if UserDefaultsManager.isInitialDisplayedHome {
                    self.linesTitle(date: "", title: "おすすめ求人一覧")
                } else {
                    let convUpdateDate = DateHelper.convStrYMD2Date(self.pageJobCards.updateAt)
                    let updateDateString = DateHelper.mdDateString(date: convUpdateDate)

                    self.linesTitle(date: updateDateString, title: "あなたにぴったりの求人")
                }
 */

                let convUpdateDate = DateHelper.convStrYMD2Date(self.pageJobCards.updateAt)
                let updateDateString = DateHelper.mdDateString(date: convUpdateDate)

                self.linesTitle(date: updateDateString, title: "あなたにぴったりの求人")
                
                self.dataAddFlag = false
                self.dataCheckAction()
            } else {
                // 精度の高い求人を受け取る
//                self.recommendUseFlag = true
                self.useApiListFlag = true
                self.getJobRecommendList()
            }
            */
        }
    }

    private func getProfileData() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("getProfile", Void(), function: #function, line: #line)
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getProfile", result, function: #function, line: #line)
            self.profile = result
            self.getResume()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getProfile", error, function: #function, line: #line)
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.profileErrorHandling(with: error)
        }
        .finally {}
    }

    private func getResume() {
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            self.resume = result
            self.getJobData()
        }
        .catch { _ in }
        .finally {}
    }

    private func profileErrorHandling(with error: Error) {
        let myError = AuthManager.convAnyError(error)
        let profileError = ProfileApiError.init(rawValue: myError.code)

        SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        if let errorType = profileError {
            switch errorType {
            case .invalidation, .oldAuthCode:
                break
            case .notAuthorized:
                transitionToInitialView()
            case .notFount:
                showConfirm()
            case .internalError:
                showRetryFetchProfile()
            }
        }
    }

    private func transitionToInitialView() {
        let vc = getVC(sbName: "InitialInputStartVC", vcName: "InitialInputStartVC") as! InitialInputStartVC
        let newNavigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = newNavigationController
    }

    private func showRetryFetchProfile() {
        let alert = UIAlertController(title: "通信エラー", message: "再度データの取得を行います。", preferredStyle:  .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in self.getProfileData() })

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showConfirm() {
        let alert = UIAlertController(title: "プロフィール入力をしてください", message: "", preferredStyle:  .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in self.transitionToInitialInput() })

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func transitionToInitialInput() {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Sbid_FirstInputPreviewVC") as! FirstInputPreviewVC
        vc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController = navi
    }

    private func setInitialDisplayedFlag() {
        UserDefaultsManager.setObject(true, key: .isInitialDisplayedHome)
    }

    #if false
    private func makeDummyData() {

        let mdlData1:MdlJobCard = MdlJobCard.init(jobCardCode: "1000000",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/06/30", endAt: "2020/07/11"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryMinCode: 7,
                                                  salaryMaxCode: 11,
                                                  salaryDisplay: true,
                                                  workPlaceCode: [1,2,3,4,5,6],
                                                  keepStatus: true)


        let mdlData2:MdlJobCard = MdlJobCard.init(jobCardCode: "2",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/16", endAt: "2020/05/31"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryMinCode: 9,
                                                  salaryMaxCode: 10,
                                                  salaryDisplay: false,
                                                  workPlaceCode: [8,9,10,11,12,13,15],
                                                  keepStatus: false)


        let mdlData3:MdlJobCard = MdlJobCard.init(jobCardCode: "3",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/01", endAt: "2020/05/31"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryMinCode: 20,
                                                  salaryMaxCode: 24,
                                                  salaryDisplay: true,
                                                  workPlaceCode: [44,45,46,47,48,49,50],
                                                  keepStatus: false)

        let nowDateString = Date().dispYmdJP()
        pageJobCards = MdlJobCardList.init(updateAt: nowDateString,
                                           hasNext: true, jobList: [
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
        ])

        dispJobCards = MdlJobCardList()
        if pageJobCards.jobCards.count > moreDataCount {
            let jobCards = pageJobCards.jobCards
            dispJobCards.jobCards = jobCards
        } else {
            for i in 0..<pageJobCards.jobCards.count {
                let data = pageJobCards.jobCards[i]
                dispJobCards.jobCards.append(data)
            }
        }
    }
    #endif

    private func makeCellHeight(row: Int) -> CGFloat {
        var rowHeight:CGFloat = defaultCellHeight
        
        if self.dispJobCards.jobCards.count == 0 {
            return 0
        }

        let jobData = self.dispJobCards.jobCards[row]

        // NEW・終了間近を確認。あれば heightを追加
        let nowDate = Date()
        // NEWマーク 表示チェック
        let start_date_string = jobData.displayPeriod.startAt
        let startPeriod = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = jobData.displayPeriod.endAt
        let endPeriod = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)

        let limitedType:LimitedType = DateHelper.limitedTypeCheck(startFlag: startPeriod, endFlag: endPeriod)

        if limitedType != LimitedType.none {
            rowHeight += 40
        }

        // 職種のサイズチェック
        // カード外 左:20pt,右20pt
        // カード内 左:24pt,右24pt
        // フォント:C_font_M
        let areaWidth = self.view.frame.size.width - ((20 * 2) + (24 * 2))
//        Log.selectLog(logLevel: .debug, "areaWidth:\(areaWidth)")

        let text = jobData.jobName
//        Log.selectLog(logLevel: .debug, "text:\(text)")
        let font = UIFont.init(fontType: .C_font_M)
        let textSize = CGFloat(text.count) * font!.pointSize
//        Log.selectLog(logLevel: .debug, "textSize:\(textSize)")

        if (textSize / areaWidth) > 2.0 {
            rowHeight += 30
        } else if textSize > areaWidth {
            rowHeight += 30
        }
        /*
        if areaWidth > textSize {
            rowHeight -= 30
        }
        */

        rowHeight = DeviceHelper.deviceAddHeight(defaultHeight: rowHeight, addHeight: 25)
        
        // iPhone5s,SEの場合縮小
        if deviceType == "iPhone5s" || deviceType == "iPhoneSE" {
            rowHeight -= 60
        }

        return rowHeight
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count && dispType == .add {
            return 100
        } else if row == dispJobCards.jobCards.count && dispType == .end {
            return 250
        }

        return self.makeCellHeight(row: row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count {
            return
        }
        let selectedJobData = dispJobCards.jobCards[row]
        let jobId = selectedJobData.jobCardCode
        // ダミーチェック
//        let jobId = "526123"
//        let jobId = "1187957"
//        let jobId = "1194358" // 画像でエラーが起きる。
//        let jobId = "1172337" // 文字化けする
//        let jobId = "1193560"   // なか卯
//        let jobId = "1199266"   // キャリアデザインセンター
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC

        vc.configure(jobId: jobId, routeFrom: .fromHome)
        vc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let jobCardsCount = dispJobCards.jobCards.count

        // 次に表示できるページが無い場合
        if pageJobCards.nextPage == false {
            dispType = .end
        } else {
            dispType = .add
        }
        return (jobCardsCount + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let jobCardsCount = dispJobCards.jobCards.count
        let row = indexPath.row
        switch dispType {
        case .add:
            if row == jobCardsCount {
                let cell = tableView.loadCell(cellName: "JobOfferCardMoreCell", indexPath: indexPath) as! JobOfferCardMoreCell
                cell.delegate = self
                return cell
            } else {
                let data = dispJobCards.jobCards[row]

                let cell = tableView.loadCell(cellName: "JobOfferBigCardCell", indexPath: indexPath) as! JobOfferBigCardCell
                cell.delegate = self
                cell.tag = row
                cell.setup(data: data)
                return cell
            }
        case .end:
            if row == dispJobCards.jobCards.count {
                let cell = tableView.loadCell(cellName: "JobOfferCardReloadCell", indexPath: indexPath) as! JobOfferCardReloadCell
                cell.delegate = self
                return cell
            } else {
                let data = dispJobCards.jobCards[row]
                let cell = tableView.loadCell(cellName: "JobOfferBigCardCell", indexPath: indexPath) as! JobOfferBigCardCell
                cell.delegate = self
                cell.tag = row
                cell.setup(data: data)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}

extension HomeVC: JobOfferCardMoreCellDelegate {
    func moreDataAdd() {
//        Log.selectLog(logLevel: .debug, "HomeVC JobOfferCardMoreCellDelegate start")
//        Log.selectLog(logLevel: .debug, "dataAddFlag:\(dataAddFlag)")
        if dataAddFlag == true {
//            Log.selectLog(logLevel: .debug, "データの追加不可")
            return
        }
        useApiListFlag ? getJobRecommendAddList() : getJobAddList()
//        recommendUseFlag ? getJobRecommendAddList() : getJobAddList()
//        Log.selectLog(logLevel: .debug, "HomeVC JobOfferCardMoreCellDelegate end")
        self.dataAddFlag = true
    }
}

extension HomeVC: NoCardViewDelegate {
    func registEditAction() {
//        // マイページへ移動
//        self.tabBarController?.selectedIndex = 2
        self.useApiListFlag = true
        self.getJobRecommendList()
    }
}

extension HomeVC: JobOfferCardReloadCellDelegate {
    func allTableReloadAction() {
        Log.selectLog(logLevel: .debug, "HomeVC allTableReloadAction start")
        // 精度の高い求人を受け取る
        self.useApiListFlag = !self.useApiListFlag
        Log.selectLog(logLevel: .debug, "self.useApiListFlag:\(self.useApiListFlag)")
        self.useApiListFlag ? getJobRecommendList() : getJobList()
//        self.recommendUseFlag ? getJobRecommendList() : getJobList()
//        self.getJobRecommendList()
    }
}

extension HomeVC: BaseJobCardCellDelegate {
    func skipAction(jobId: String) {
        AnalyticsEventManager.track(type: .skipVacancies)

        if skipSendStatus == .sending {
            return
        }

        self.skipSendStatus = .sending

        var jobCardIndex:Int = 0
        for i in 0..<dispJobCards.jobCards.count {
            let jobCard = dispJobCards.jobCards[i]
            if jobCard.jobCardCode == jobId {
                jobCardIndex = i
                break
            } else {
                continue
            }
        }

        var successFlag:Bool = false
        ApiManager.sendJobSkip(id: jobId)
            .done { result in

                successFlag = true
        }.catch{ (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }.finally {
            if successFlag {
                successFlag = false
                self.dispJobCards.jobCards.remove(at: jobCardIndex)
                let deleteIndex = IndexPath(row: jobCardIndex, section: 0)

                self.homeTableView.performBatchUpdates({
                    self.homeTableView.deleteRows(at: [deleteIndex], with: .left)
                }, completion: { finished in
                    if finished {
                        self.skipSendStatus = .none
                    }
                })
            }
        }
    }
    
    func trackKeepActionEvent() {
        keepIdListForAppsFlyer.forEach({ id in
            guard trackedKeepIdListForAppsFlyer
                .first(where: { $0 == id }) == nil else { return }
            AnalyticsEventManager.track(type: .keep)
        })
        trackedKeepIdListForAppsFlyer = keepIdListForAppsFlyer
    }

    func keepAction(jobId: String, newStatus: Bool) {
        if self.keepSendStatus == .sending { return }
        //LogManager.appendLogEx(.keepList, String(repeating: "🔖", count: 11), "[jobId: \(jobId)]", "[keepSendStatus: \(keepSendStatus)]", #function, #line)
        if newStatus {
            keepIdListForAppsFlyer.append(jobId)
        } else {
            keepIdListForAppsFlyer.removeAll(where: { $0 == jobId})
        }

        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        self.keepSendStatus = .sending
        // TODO:通信処理
        var jobCard:MdlJobCard = MdlJobCard()
        for i in 0..<dispJobCards.jobCards.count {
            let checkJobCard = dispJobCards.jobCards[i]
            if checkJobCard.jobCardCode == jobId {
                jobCard = checkJobCard
                break
            } else {
                continue
            }
        }
        let jobId = jobCard.jobCardCode
        let flag = !jobCard.keepStatus
        jobCard.keepStatus = flag
        if newStatus == true {
            LogManager.appendApiLog("sendJobKeep", "[jobId: \(jobId)]", function: #function, line: #line)
            ApiManager.sendJobKeep(id: jobId)
            .done { result in
                LogManager.appendApiResultLog("sendJobKeep", result, function: #function, line: #line)
            }.catch{ (error) in
                LogManager.appendApiErrorLog("sendJobKeep", error, function: #function, line: #line)
                Log.selectLog(logLevel: .debug, "keep send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                //フェッチ後の表示更新はKeepManagerに任せる
                self.keepSendStatus = .none
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "keep delete error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                //フェッチ後の表示更新はKeepManagerに任せる
                //// セルの設定変更パターン
                self.keepSendStatus = .none
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            }
        }
    }

}

extension HomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Log.selectLog(logLevel: .debug, "HomeVC didSelect start")

        if let vcs = tabBarController.viewControllers {
            Log.selectLog(logLevel: .debug, "vcs:\(vcs)")
            
            let secondNavi = vcs[1] as! BaseNaviController
            let secondVC = secondNavi.visibleViewController as! KeepListVC
            
            Log.selectLog(logLevel: .debug, "secondVC:\(String(describing: secondVC))")
        }
    }
}
