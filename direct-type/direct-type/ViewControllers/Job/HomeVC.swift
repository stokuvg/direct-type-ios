//
//  HomeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum CardDispType:Int {
    case none   // 何も無い
    case add    // 追加
    case end    // 最後まで表示
}

class HomeVC: TmpNaviTopVC {
    @IBOutlet weak var homeTableView:UITableView!
    
    @IBOutlet weak var noCardBackView:UIView!
    
    var dispTableData:[[String: Any]] = []
    var masterTableData:[[String:Any]] = []
    
    var moreCnt:Int = 1
    var dispType:CardDispType = .none

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title(name: "あなたにぴったりの求人")
        
        // TODO:初回リリースでは外す
//        self.setRightSearchBtn()
        
        homeTableView.backgroundColor = UIColor.init(colorType: .color_base)
        homeTableView.rowHeight = 600
        
        homeTableView.registerNib(nibName: "JobOfferBigCardCell", idName: "JobOfferBigCardCell")        // 求人カード
        homeTableView.registerNib(nibName: "JobOfferCardMoreCell", idName: "JobOfferCardMoreCell")      // もっと見る
        homeTableView.registerNib(nibName: "JobOfferCardReloadCell", idName: "JobOfferCardReloadCell")// 全求人カード表示/更新
        
        self.makeDummyData()
        if masterTableData.count > 0 {
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
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        }
        //[Dbg]^^^
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func makeDummyData() {
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
    }

}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == dispTableData.count && dispType == .add {
            return 100
        } else if row == dispTableData.count && dispType == .end {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == dispTableData.count {
            return
        }
        
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 表示可能なデータの数と現在表示している数が同じ
        if masterTableData.count == dispTableData.count {
            dispType = .end
            return (dispTableData.count + 1)
        } else {
            dispType = .add
            return (dispTableData.count + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch dispType {
        case .add:
            if row == dispTableData.count {
                let cell = tableView.loadCell(cellName: "JobOfferCardMoreCell", indexPath: indexPath) as! JobOfferCardMoreCell
                cell.delegate = self
                return cell
            } else {
                let data = dispTableData[row]
                let cell = tableView.loadCell(cellName: "JobOfferBigCardCell", indexPath: indexPath) as! JobOfferBigCardCell
                cell.setup(data: data)
                return cell
            }
        case .end:
            if row == dispTableData.count {
                let cell = tableView.loadCell(cellName: "JobOfferCardReloadCell", indexPath: indexPath) as! JobOfferCardReloadCell
                cell.delegate = self
                return cell
            } else {
                let data = dispTableData[row]
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
        let checkCount = masterTableData.count - dispTableData.count
        // パターン 同じ:0 マスタの方が多い:1 表示の方が多い:これは無いはず
        if checkCount == 0 {
            // 同じ数
        } else if checkCount > 0 {
            // マスタの方が多い
            
            // 追加で表示する数より、残りの表示する数の方が多い
            if checkCount == moreDataCount {
                for i in 0..<moreDataCount {
                    let cnt = i+(moreCnt*10)
                    let data = masterTableData[cnt]
                    dispTableData.append(data)
                }
                self.homeTableView.reloadData()
            } else if checkCount > moreDataCount {
                for i in 0..<moreDataCount {
                    let cnt = i+(moreCnt*10)
                    let data = masterTableData[cnt]
                    dispTableData.append(data)
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
