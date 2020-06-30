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
    
//    @IBOutlet weak var homeNaviBackView:UIView!
//    @IBOutlet weak var homeNaviHeight:NSLayoutConstraint!
    @IBOutlet weak var homeTableView:UITableView!
    
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
    var recommendUseFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.selectLog(logLevel: .debug, "HomeVC viewDidLoad start")

        // Do any additional setup after loading the view.
        
        // TODO:初回リリースでは外す
//        self.setRightSearchBtn()
        
        homeTableView.backgroundColor = UIColor.init(colorType: .color_base)
        homeTableView.rowHeight = UITableView.automaticDimension
        
        homeTableView.registerNib(nibName: "JobOfferBigCardCell", idName: "JobOfferBigCardCell")        // 求人カード
        homeTableView.registerNib(nibName: "JobOfferCardMoreCell", idName: "JobOfferCardMoreCell")      // もっと見る
        homeTableView.registerNib(nibName: "JobOfferCardReloadCell", idName: "JobOfferCardReloadCell")// 全求人カード表示/更新
        
//        self.makeDummyData()
//        self.dataCheckAction()

//        self.getJobList()
//        self.saveHomeDisplayFlag()

        self.getJobList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.selectLog(logLevel: .debug, "HomeVC viewWillAppear start")
        
        safeAreaTop = self.view.safeAreaInsets.top
        
        //[Dbg]___
        if Constants.DbgAutoPushVC {
            switch Constants.DbgAutoPushVCNum {
            case 1: pushViewController(.profilePreviewH2)
            case 2: pushViewController(.resumePreviewH3)
            case 3: pushViewController(.careerPreviewC15)
            case 4: pushViewController(.smoothCareerPreviewF11)
            case 5: pushViewController(.firstInputPreviewA)
            case 6: pushViewController(.careerListC)
            case 7: pushViewController(.entryVC)
            default: break
            }
        }
        //[Dbg]^^^
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

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
        
        if (pageJobCards.jobCards.count) > 0 {
//        if masterTableData.count > 0 {
            homeTableView.isHidden = false
            dispType = .add
            
            self.dispJobCards = self.pageJobCards
            
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            self.homeTableView.reloadData()
        } else {
            dispType = .none
            let cardNoView = UINib(nibName: "NoCardView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)
                .first as! NoCardView
            var cardFrame = cardNoView.frame
            cardFrame = noCardBackView.frame
            cardNoView.frame = cardFrame
            cardNoView.delegate = self
            noCardBackView.addSubview(cardNoView)
            
            homeTableView.isHidden = true
        }
    }
    
    private func getJobRecommendAddList() {
        SVProgressHUD.show()
        pageNo += 1
        pageJobCards = MdlJobCardList()
        ApiManager.getRecommendJobs(pageNo, isRetry: true)
            .done { result in
                Log.selectLog(logLevel: .debug, "getJobRecommendAddList result:\(result.debugDisp)")
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss()
            self.dataAddAction()
        }
    }
    
    private func getJobAddList() {
        SVProgressHUD.show()
        pageNo += 1
        pageJobCards = MdlJobCardList()
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                Log.selectLog(logLevel: .debug, "getJobAddList result:\(result.debugDisp)")
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss()
            self.dataAddAction()
        }
    }
    private func recommendLoad() {
        Log.selectLog(logLevel: .debug, "HomeVC recommendLoad start")
        pageJobCards = MdlJobCardList()
        dispJobCards = MdlJobCardList()
        pageNo = 1
        ApiManager.getRecommendJobs(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getRecommendJobs result:\(result.debugDisp)")
                
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss()
            self.dataCheckAction()
        }
    }
    
    private func getJobList() {
        Log.selectLog(logLevel: .debug, "HomeVC getJobList start")
        SVProgressHUD.show()
        pageJobCards = MdlJobCardList()
        dispJobCards = MdlJobCardList()
        pageNo = 1
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getJobs result:\(result.debugDisp)")
                
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            let (homeFlag,pushFlag) = self.getHomeDisplayFlag()
            Log.selectLog(logLevel: .debug, "homeFlag:\(homeFlag)")
            Log.selectLog(logLevel: .debug, "pushFlag:\(pushFlag)")
//            let flag = false
            if homeFlag == true, pushFlag == false {
                let convUpdateDate = DateHelper.convStrYMD2Date(self.pageJobCards.updateAt)
//                    Log.selectLog(logLevel: .debug, "convUpdateDate:\(String(describing: convUpdateDate))")
                
                let updateDateString = DateHelper.mdDateString(date: convUpdateDate)
//                    Log.selectLog(logLevel: .debug, "updateDateString:\(String(describing: updateDateString))")
                
                self.linesTitle(date: updateDateString, title: "あなたにぴったりの求人")
            } else {
                self.linesTitle(date: "", title: "おすすめ求人一覧")
            }
            SVProgressHUD.dismiss()
            self.dataCheckAction()

            self.saveHomeDisplayFlag()
        }
    }
    
    private func getHomeDisplayFlag() -> (Bool,Bool) {
        let ud = UserDefaults.standard
        let homeFlag = ud.bool(forKey: "home")
        let pushFlag = ud.bool(forKey: "pushTab")
        return (homeFlag,pushFlag)
    }
    
    private func saveHomeDisplayFlag() {
        Log.selectLog(logLevel: .debug, "saveHomeDisplayFlag start")
        let ud = UserDefaults.standard
        ud.set(true, forKey: "home")
        ud.set(false, forKey: "pushTab")
        ud.synchronize()
    }

    #if false
    private func makeDummyData() {
        
        let mdlData1:MdlJobCard = MdlJobCard.init(jobCardCode: "1",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/16", endAt: "2020/05/28"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryMinCode: 7,
                                                  salaryMaxCode: 11,
                                                  salaryDisplay: true,
                                                  workPlaceCode: [1,2,3,4,5,6],
                                                  keepStatus: false,
                                                  skipStatus: false,
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        
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
                                                  keepStatus: false,
                                                  skipStatus: false,
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        
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
                                                  keepStatus: false,
                                                  skipStatus: false,
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        let nowDateString = Date().dispYmdJP()
        masterJobCards = MdlJobCardList.init(updateAt: nowDateString, jobCards: [
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
            mdlData1,mdlData2,mdlData3,
        ])
        /*
        masterJobCards = MdlJobCardList.init(jobCards:
            [
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
            ]
        )
        */
        
        dispJobCards = MdlJobCardList()
        if masterJobCards.jobCards.count > moreDataCount {
            let jobCards = masterJobCards.jobCards
            dispJobCards.jobCards = jobCards
        } else {
            for i in 0..<masterJobCards.jobCards.count {
                let data = masterJobCards.jobCards[i]
                dispJobCards.jobCards.append(data)
            }
        }
        
        /*
        if masterTableData.count > moreDataCount {
            for i in 0..<moreDataCount {
                let data = masterTableData[i]
                dispTableData.append(data)
            }
        } else {
            for i in 0..<masterTableData.count {
                let data = masterTableData[i]
                dispTableData.append(data)
            }
        }
         
        let data1:[String:Any] = [
            "end":true,
            "image":"https://type.jp/s/img_banner/top_pc_side_number1.jpg",
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"850",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
        let data2:[String:Any] = [
            "end":false,
            "image":"https://type.jp/s/img_banner/top_pc_side_number1.jpg",
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"850",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！\nメディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
        let data3:[String:Any] = [
            "end":false,
            "image":"https://type.jp/s/img_banner/top_pc_side_number1.jpg",
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！\nメディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
//        for _ in 0..<100 {
        for i in 0..<15 {
            let cnt = i % 3
//            let randomValue = Int.random(in: 1...3)
            switch cnt {
                case 0:
                    masterTableData.append(data1)
                case 1:
                    masterTableData.append(data2)
                case 2:
                    masterTableData.append(data3)
                default:
                    masterTableData.append(data1)
            }
        }
        
        if masterTableData.count > moreDataCount {
            for i in 0..<moreDataCount {
                let data = masterTableData[i]
                dispTableData.append(data)
            }
        } else {
            for i in 0..<masterTableData.count {
                let data = masterTableData[i]
                dispTableData.append(data)
            }
        }
        */
    }
    #endif
    
    private func recommendSend() {
        SVProgressHUD.show()
        RecommendManager.fetchRecommend(type: .ap112, jobID: "")
        .done { result in
            Log.selectLog(logLevel: .debug, "求人一覧のレコメンド 成功:\(result)")
            
//            self.pageJobCards = result
            self.recommendLoad()
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            SVProgressHUD.dismiss()
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            Log.selectLog(logLevel: .debug, "求人一覧のレコメンド エラー:\(myErr.debugDisp)")
        }
        .finally {
            self.homeTableView.reloadData()
        }
    }
    
    private func makeCellHeight(row: Int) -> CGFloat {
        var rowHeight:CGFloat = defaultCellHeight
        
        let jobData = self.dispJobCards.jobCards[row]
        
        // NEW・終了間近を確認。あれば heightを追加
        let nowDate = Date()
        // NEWマーク 表示チェック
        let start_date_string = jobData.displayPeriod.startAt
//        Log.selectLog(logLevel: .debug, "start_date_string:\(start_date_string)")
        let startPeriod = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = jobData.displayPeriod.endAt
//        Log.selectLog(logLevel: .debug, "end_date_string:\(end_date_string)")
        let endPeriod = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
        
        var limitedType:LimitedType!
        switch (startPeriod,endPeriod) {
            case (false,false):
//                Log.selectLog(logLevel: .debug, "両方当たる")
                // 終了マークのみ表示
                limitedType = LimitedType.none
            case (false,true):
//                Log.selectLog(logLevel: .debug, "掲載開始から７日以内")
                // NEWマークのみ表示
                limitedType = .new
            case (true,false):
//                Log.selectLog(logLevel: .debug, "掲載終了まで７日以内")
                // 終了マークのみ表示
                limitedType = .end
            default:
//                Log.selectLog(logLevel: .debug, "それ以外")
                limitedType = LimitedType.none
        }
        
        if limitedType != LimitedType.none {
            rowHeight += 40
        }
        rowHeight = DeviceHelper.deviceAddHeight(defaultHeight: rowHeight, addHeight: 25)
        
        return rowHeight
//        return UITableView.automaticDimension
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
//        return defaultCellHeight
//        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count {
//        if row == dispTableData.count {
            return
        }
        let selectedJobData = dispJobCards.jobCards[row]
        let jobId = selectedJobData.jobCardCode
        
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC
        vc.jobId = jobId
        
        vc.hidesBottomBarWhenPushed = true
        
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
//                Log.selectLog(logLevel: .debug, "data.keepStatus:\(data.keepStatus)")
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
//                Log.selectLog(logLevel: .debug, "data.keepStatus:\(data.keepStatus)")
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
        // 次ページの求人情報を取得
        if recommendUseFlag {
            self.getJobRecommendAddList()
        } else {
            self.getJobAddList()
        }
    }
}

extension HomeVC: NoCardViewDelegate {
    func registEditAction() {
        // マイページへ移動
        self.tabBarController?.selectedIndex = 2
    }
}

extension HomeVC: JobOfferCardReloadCellDelegate {
    func allTableReloadAction() {
        Log.selectLog(logLevel: .debug, "allTableReloadAction start")
        // 精度の高い求人を受け取る
        self.recommendUseFlag = true
        self.recommendSend()
    }
}

extension HomeVC: BaseJobCardCellDelegate {
    func skipAction(jobId: String) {
        Log.selectLog(logLevel: .debug, "skipAction jobId:\(jobId)")
        
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
            }
        }
        
        Log.selectLog(logLevel: .debug, "delete dispJobCards.jobCards.count:\(dispJobCards.jobCards.count)")
        Log.selectLog(logLevel: .debug, "delete jobid:\(jobId)")
        Log.selectLog(logLevel: .debug, "delete jobCardIndex:\(jobCardIndex)")
        
        var successFlag:Bool = false
        ApiManager.sendJobSkip(id: jobId)
            .done { result in
            Log.selectLog(logLevel: .debug, "skip send success")
                Log.selectLog(logLevel: .debug, "見送り成功")
                
                successFlag = true
        }.catch{ (error) in
            Log.selectLog(logLevel: .debug, "skip send error:\(error)")
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }.finally {
            Log.selectLog(logLevel: .debug, "skip send finally")
            if successFlag {
                successFlag = false
                self.dispJobCards.jobCards.remove(at: jobCardIndex)
                let deleteIndex = IndexPath(row: jobCardIndex, section: 0)
                
                /*
                // TODO:スピードを変えるのは難しい？
                UIView.animate(withDuration: 0.0,
                               animations: {
                                   self.homeTableView.deleteRows(at: [deleteIndex], with: .automatic)
                }, completion: { finished in
                    if finished {
                        self.skipSendStatus = .none
                    }
                })
                */
                
                self.homeTableView.performBatchUpdates({
                    self.homeTableView.deleteRows(at: [deleteIndex], with: .automatic)
                }, completion: { finished in
                    if finished {
                        self.skipSendStatus = .none
                    }
                })
            }
        }
    }
    
    func keepAction(tag: Int) {
//        Log.selectLog(logLevel: .debug, "keepAction tag:\(tag)")
        if self.keepSendStatus == .sending { return }
        
        self.keepSendStatus = .sending
        // TODO:通信処理
        let row = tag
        let jobCard = dispJobCards.jobCards[row]
        let jobId = jobCard.jobCardCode
        let flag = !jobCard.keepStatus
        jobCard.keepStatus = flag
        if flag == true {
//            Log.selectLog(logLevel: .debug, "キープ追加:jobId:\(jobId)")
            
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
//                    Log.selectLog(logLevel: .debug, "keep send success")
//                    Log.selectLog(logLevel: .debug, "keep成功")
                    
            }.catch{ (error) in
//                Log.selectLog(logLevel: .debug, "keep send error:\(error)")
                
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
//                Log.selectLog(logLevel: .debug, "keep send finally")
                self.dispJobCards.jobCards[tag] = jobCard
                let updateIndex = IndexPath.init(row: tag, section: 0)
                self.homeTableView.performBatchUpdates({
                    self.homeTableView.reloadRows(at: [updateIndex], with: .automatic)
                }, completion: { finished in
                    if finished {
                        self.keepSendStatus = .none
                    }
                })
            }
        } else {
//            Log.selectLog(logLevel: .debug, "キープ削除:jobId:\(jobId)")
            
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
//                    Log.selectLog(logLevel: .debug, "keep delete success")
//                    Log.selectLog(logLevel: .debug, "delete成功")
                    
            }.catch{ (error) in
//                Log.selectLog(logLevel: .debug, "keep delete error:\(error)")
                
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
//                Log.selectLog(logLevel: .debug, "keep delete finally")
                
                self.dispJobCards.jobCards[tag] = jobCard
                let updateIndex = IndexPath.init(row: tag, section: 0)
                self.homeTableView.performBatchUpdates({
                    self.homeTableView.reloadRows(at: [updateIndex], with: .automatic)
                }, completion: { finished in
                    if finished {
                        self.keepSendStatus = .none
                    }
                })
            }
        }
    }
    
}
