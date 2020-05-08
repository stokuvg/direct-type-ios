//
//  HomeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HomeVC: TmpNaviTopVC {
    @IBOutlet weak var homeTableView:UITableView!
    
    @IBOutlet weak var noCardBackView:UIView!
    
    var dispTableData:[[String: Any]] = []
    var masterTableData:[[String:Any]] = []
    
    var moreBtnDispFlag:Bool = false
    var moreCnt:Int = 1
    var noCardFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title(name: "あなたにぴったりの求人")
        
        homeTableView.rowHeight = 600
        
        homeTableView.registerNib(nibName: "JobOfferBigCardCell", idName: "JobOfferBigCardCell")
        homeTableView.registerNib(nibName: "JobOfferCardMoreCell", idName: "JobOfferCardMoreCell")
        homeTableView.registerNib(nibName: "JobNoOfferCardCell", idName: "JobNoOfferCardCell")
        
        self.makeDummyData()
        if masterTableData.count > 0 {
            homeTableView.isHidden = false
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            self.homeTableView.reloadData()
        } else {
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
        NSLog("HomeVC viewWillAppear start")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("HomeVC viewDidAppear start")
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
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円\nPG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"850",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！\nメディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
        let data3:[String:Any] = [
            "end":false,
            "image":"https://type.jp/s/img_banner/top_pc_side_number1.jpg",
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円\nPG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！\nメディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
//        for _ in 0..<100 {
        for _ in 0..<15 {
            let randomValue = Int.random(in: 1...3)
            switch randomValue {
                case 1:
                    masterTableData.append(data1)
                case 2:
                    masterTableData.append(data2)
                case 3:
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
        if row == dispTableData.count && moreBtnDispFlag {
            return 70
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
        if masterTableData.count == 0 {
            noCardFlag = true
            return 1
        }
        noCardFlag = true
        if masterTableData.count > dispTableData.count {
            moreBtnDispFlag = true
            return (dispTableData.count + 1)
        } else {
            moreBtnDispFlag = false
            return dispTableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        // row の最後がもっと見るボタンかどうか
        if moreBtnDispFlag == true && (row == dispTableData.count) {
            let cell = tableView.loadCell(cellName: "JobOfferCardMoreCell", indexPath: indexPath) as! JobOfferCardMoreCell
            cell.delegate = self
            return cell
        } else {
            let data = dispTableData[row]
            let cell = tableView.loadCell(cellName: "JobOfferBigCardCell", indexPath: indexPath) as! JobOfferBigCardCell
            cell.setup(data: data)
            return cell
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
