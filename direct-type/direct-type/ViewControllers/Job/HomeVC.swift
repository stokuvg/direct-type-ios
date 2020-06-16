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

class HomeVC: TmpNaviTopVC {
    
    @IBOutlet weak var noCardBackView:UIView!
    
//    @IBOutlet weak var homeNaviBackView:UIView!
//    @IBOutlet weak var homeNaviHeight:NSLayoutConstraint!
    @IBOutlet weak var homeTableView:UITableView!
    
    var pageJobCards: MdlJobCardList!   // nページを取得
//    var masterJobCards: MdlJobCardList!
    var dispJobCards: MdlJobCardList!   // 取得したページを全て表示
    
//    var dispTableData:[[String: Any]] = []
//    var masterTableData:[[String:Any]] = []
    
    var moreCnt:Int = 1
    var dispType:CardDispType = .none
    
    var safeAreaTop:CGFloat!
    
    var pageNo:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.selectLog(logLevel: .debug, "HomeVC viewDidLoad start")

        // Do any additional setup after loading the view.
        
        let flag = self.getHomeDisplayFlag()
        if flag {
            self.linesTitle(date: Date().dispHomeDate(), title: "あなたにぴったりの求人")
        } else {
            self.title(name: "おすすめ求人一覧")
//            self.linesTitle(date: Date().dispHomeDate(), title: "あなたにぴったりの求人")
        }
        
        // TODO:初回リリースでは外す
//        self.setRightSearchBtn()
        
        homeTableView.backgroundColor = UIColor.init(colorType: .color_base)
        homeTableView.rowHeight = 600
        
        homeTableView.registerNib(nibName: "JobOfferBigCardCell", idName: "JobOfferBigCardCell")        // 求人カード
        homeTableView.registerNib(nibName: "JobOfferCardMoreCell", idName: "JobOfferCardMoreCell")      // もっと見る
        homeTableView.registerNib(nibName: "JobOfferCardReloadCell", idName: "JobOfferCardReloadCell")// 全求人カード表示/更新
        
//        self.makeDummyData()
//        self.dataCheckAction()

//        self.getJobList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.selectLog(logLevel: .debug, "HomeVC viewWillAppear start")
        
        safeAreaTop = self.view.safeAreaInsets.top
        
        //[Dbg]___
        if Constants.DbgAutoPushVC {
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            switch Constants.DbgAutoPushVCNum {
            case 1:
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfilePreviewVC") as? ProfilePreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case 2:
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ResumePreviewVC") as? ResumePreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case 3:
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case 4:
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case 5:
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_FirstInputPreviewVC") as? FirstInputPreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case 6:
            let storyboard2 = UIStoryboard(name: "Career", bundle: nil)
            if let nvc = storyboard2.instantiateViewController(withIdentifier: "Sbid_CareerListVC") as? CareerListVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            default: break
            }
        }
        //[Dbg]^^^
        
        self.getJobList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
    
    private func getJobAddList() {
        SVProgressHUD.show()
        pageNo += 1
        pageJobCards = MdlJobCardList()
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
            switch myErr.code {
                case 403:
                    let message:String = "idTokenを取得していません"
                    self.showConfirm(title: "通信失敗", message: message)
                        .done { _ in

                    }.catch { (error) in

                    }.finally {
                }
                default:
                    break
            }
        }
        .finally {
            SVProgressHUD.dismiss()
//            self.dataCheckAction()
            self.dataAddAction()
        }
    }
    
    private func getJobList() {
        SVProgressHUD.show()
        pageJobCards = MdlJobCardList()
        dispJobCards = MdlJobCardList()
        ApiManager.getJobs(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getJobs result:\(result.debugDisp)")
                debugLog("ApiManager getJobs result.jobCards:\(result.jobCards)")
                
                self.pageJobCards = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
            switch myErr.code {
                case 403:
                    let message:String = "idTokenを取得していません"
                    self.showConfirm(title: "通信失敗", message: message)
                        .done { _ in

                    }.catch { (error) in

                    }.finally {
                }
                default:
                    break
            }
        }
        .finally {
            SVProgressHUD.dismiss()
            self.dataCheckAction()
        }
    }
    
    private func getHomeDisplayFlag() -> Bool {
        let ud = UserDefaults.standard
        let homeFlag = ud.bool(forKey: "home")
        return homeFlag
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
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count && dispType == .add {
            return 100
        } else if row == dispJobCards.jobCards.count && dispType == .end {
            return 250
        }
        return 600
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let jobCardsCount = dispJobCards.jobCards.count
        
        // 次に表示できるページが無い場合
        if pageJobCards.nextPage == false{
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
//            if row == dispTableData.count {
                let cell = tableView.loadCell(cellName: "JobOfferCardMoreCell", indexPath: indexPath) as! JobOfferCardMoreCell
                cell.delegate = self
                return cell
            } else {
                let data = dispJobCards.jobCards[row]
//                let data = dispTableData[row]
                
                let cell = tableView.loadCell(cellName: "JobOfferBigCardCell", indexPath: indexPath) as! JobOfferBigCardCell
                cell.delegate = self
                cell.tag = row
                cell.setup(data: data)
                return cell
            }
        case .end:
            if row == dispJobCards.jobCards.count {
//            if row == dispTableData.count {
                let cell = tableView.loadCell(cellName: "JobOfferCardReloadCell", indexPath: indexPath) as! JobOfferCardReloadCell
                cell.delegate = self
                return cell
            } else {
                let data = dispJobCards.jobCards[row]
//                let data = dispTableData[row]
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
        // 次ページの求人情報を取得
        self.getJobAddList()
    }
}

extension HomeVC: NoCardViewDelegate {
    func registEditAction() {
        // マイページへ移動
        self.tabBarController?.selectedIndex = 3
    }
}

extension HomeVC: JobOfferCardReloadCellDelegate {
    func allTableReloadAction() {
        Log.selectLog(logLevel: .debug, "allTableReloadAction start")
        // 精度の高い求人を受け取る
        self.homeTableView.reloadData()
    }
}

extension HomeVC: BaseJobCardCellDelegate {
    func skipAction(tag: Int) {
        Log.selectLog(logLevel: .debug, "skipAction tag:\(tag)")
        
        let row = tag
        
        let jobCard = dispJobCards.jobCards[row]
        let jobId = jobCard.jobCardCode
        ApiManager.sendJobSkip(id: jobId)
            .done { result in
            Log.selectLog(logLevel: .debug, "skip send success")
                Log.selectLog(logLevel: .debug, "見送り成功")
                // TODO:通信処理
                
                //            return (jobCardsCount + 1)
                self.dispJobCards.jobCards.remove(at: row)
                
                let deleteIndex = IndexPath(row: row, section: 0)
                
                // TODO:スピードを変えるのは難しい？
                self.homeTableView.deleteRows(at: [deleteIndex], with: .automatic)
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
            Log.selectLog(logLevel: .debug, "skip send finally")
        }
    }
    
    func keepAction(tag: Int) {
        Log.selectLog(logLevel: .debug, "keepAction tag:\(tag)")
        // TODO:通信処理
        let row = tag
        let jobCard = dispJobCards.jobCards[row]
        let jobId = jobCard.jobCardCode
        let flag = !jobCard.keepStatus
        jobCard.keepStatus = flag
        if flag == true {
            Log.selectLog(logLevel: .debug, "キープ追加:jobId:\(jobId)")
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "keep send error:\(error)")
                
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                    case 404:
                        self.showError(error)
                    default:
                        self.showError(error)
                }
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                self.dispJobCards.jobCards[tag] = jobCard
                let updateIndex = IndexPath.init(row: tag, section: 0)
                self.homeTableView.reloadRows(at: [updateIndex], with: .automatic)
            }
        } else {
            Log.selectLog(logLevel: .debug, "キープ削除:jobId:\(jobId)")
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "keep delete error:\(error)")
                
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                    case 404:
                        self.showError(error)
                    default:
                        self.showError(error)
                }
            }.finally {
                Log.selectLog(logLevel: .debug, "keep delete finally")
            }
        }
    }
    
    
}
