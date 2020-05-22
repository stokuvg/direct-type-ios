//
//  HomeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

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
    
    var masterJobCards: MdlJobCardList!
    var dispJobCards: MdlJobCardList = MdlJobCardList.init()
    
//    var dispTableData:[[String: Any]] = []
//    var masterTableData:[[String:Any]] = []
    
    var moreCnt:Int = 1
    var dispType:CardDispType = .none

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.makeDummyData()
        if (masterJobCards.jobCards.count) > 0 {
//        if masterTableData.count > 0 {
            homeTableView.isHidden = false
            dispType = .add
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            self.homeTableView.reloadData()
        } else {
            dispType = .none
            let cardNoView = UINib(nibName: "NoCardView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)
                .first as! NoCardView
            cardNoView.delegate = self
            noCardBackView.addSubview(cardNoView)
            
            homeTableView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
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
            default: break
            }
        }
        //[Dbg]^^^
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    private func getHomeDisplayFlag() -> Bool {
        let ud = UserDefaults.standard
        let homeFlag = ud.bool(forKey: "home")
        return homeFlag
    }
    
    private func makeDummyData() {
        
        let mdlData1:MdlJobCard = MdlJobCard.init(jobCardCode: "1",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/16", endAt: "2020/05/28"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryCode: [7,11],
                                                  workPlaceCode: [1,44],
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        
        let mdlData2:MdlJobCard = MdlJobCard.init(jobCardCode: "2",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/01", endAt: "2020/05/31"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryCode: [7,11],
                                                  workPlaceCode: [1,44],
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        
        let mdlData3:MdlJobCard = MdlJobCard.init(jobCardCode: "3",
                                                  displayPeriod: EntryFormInfoDisplayPeriod.init(startAt: "2020/05/01", endAt: "2020/05/31"),
                                                  companyName: "株式会社キャリアデザインITパートナーズ「type」",
                                                  jobName: "PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
                                                  mainTitle: "メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
                                                  mainPicture: "https://type.jp/s/img_banner/top_pc_side_number1.jpg",
                                                  salaryCode: [7,11],
                                                  workPlaceCode: [1,44],
                                                  userFilter: UserFilterInfo.init(tudKeepStatus: true, tudSkipStatus: true))
        
        masterJobCards = MdlJobCardList.init(jobCards:
            [
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
                mdlData1,mdlData2,mdlData3,
            ]
        )
        
        if masterJobCards.jobCards.count > moreDataCount {
            for i in 0..<moreDataCount {
                let jobCardBig = masterJobCards.jobCards[i]
                dispJobCards.jobCards.append(jobCardBig)
            }
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

}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count && dispType == .add {
//        if row == dispTableData.count && dispType == .add {
            return 100
        } else if row == dispJobCards.jobCards.count && dispType == .end {
//        } else if row == dispTableData.count && dispType == .end {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == dispJobCards.jobCards.count {
//        if row == dispTableData.count {
            return
        }
        
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 表示可能なデータの数と現在表示している数が同じ
        let jobCardsCount = dispJobCards.jobCards.count
        
        if masterJobCards.jobCards.count == dispJobCards.jobCards.count {
//        if masterTableData.count == dispTableData.count {
            dispType = .end
            return (jobCardsCount + 1)
//            return (dispTableData.count + 1)
        } else {
            dispType = .add
            return (jobCardsCount + 1)
//            return (dispTableData.count + 1)
        }
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
        // 現在の数とマスタの数を比較
        let masterCount = masterJobCards.jobCards.count
        let dispCount = dispJobCards.jobCards.count
        let checkCount = (masterCount - dispCount)
//        let checkCount = masterTableData.count - dispTableData.count
        // パターン 同じ:0 マスタの方が多い:1 表示の方が多い:これは無いはず
        if checkCount == 0 {
            // 同じ数
        } else if checkCount > 0 {
            // マスタの方が多い
            
            // 追加で表示する数より、残りの表示する数の方が多い
            if checkCount == moreDataCount {
                for i in 0..<moreDataCount {
                    let cnt = i+(moreCnt*10)
                    let jobCard = masterJobCards.jobCards[cnt]
//                    let data = masterTableData[cnt]
                    dispJobCards.jobCards.append(jobCard)
//                    dispTableData.append(data)
                }
                self.homeTableView.reloadData()
            } else if checkCount > moreDataCount {
                for i in 0..<moreDataCount {
                    let cnt = i+(moreCnt*10)
                    let jobCard = masterJobCards.jobCards[cnt]
                    dispJobCards.jobCards.append(jobCard)
//                    let data = masterTableData[cnt]
//                    dispTableData.append(data)
                }
                self.homeTableView.reloadData()
            } else {
                
            }
        } else {
            
        }
    }
}

extension HomeVC: NoCardViewDelegate {
    func registEditAction() {
    }
}

extension HomeVC: JobOfferCardReloadCellDelegate {
    func allTableReloadAction() {
        Log.selectLog(logLevel: .debug, "allTableReloadAction start")
        // 精度の高い求人を受け取る
        self.homeTableView.reloadData()
    }
}
