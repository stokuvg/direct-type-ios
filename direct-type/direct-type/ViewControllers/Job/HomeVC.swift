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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title(name: "あなたにぴったりの求人")
        
        homeTableView.rowHeight = 600
        
        homeTableView.registerNib(nibName: "JobOfferBigCard", idName: "JobOfferBigCard")
    }

}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
            case 0:
//                return 600
                return UITableView.automaticDimension
            
        default:
            return UITableView.automaticDimension
        }
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.loadCell(cellName: "JobOfferBigCard", indexPath: indexPath) as! JobOfferBigCard
        let row = indexPath.row
        let data:[String:Any] = [
            "row":row,
            "end":true,
            "job":"PG・SE◆ユーザー直取引多数◆上流工程◆残業月15h◆年間休日128日◆[PG]平均月収25~35万円",
            "price":"500~700",
            "special":"850",
            "area":"東京都23区内",
            "company":"株式会社キャリアデザインITパートナーズ「type」",
            "main":"メディアで話題のヘルスケアアプリ運営企業!未経験からWebのお仕事にチャレンジしたい方、歓迎です！",
        ]
        
        cell.setup(data: data)
        
        return cell
    }
    
    
}
