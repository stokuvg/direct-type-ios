//
//  JobOfferDetailVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobOfferDetailVC: TmpBasicVC {
    
    @IBOutlet weak var detailTableView:UITableView!
    
    var buttonsView:NaviButtonsView!
    
    let dummyData:[String:Any] = [
        "end":true,
        "images":["https://type.jp/s/img_banner/top_pc_side_number1.jpg","https://type.jp/s/campaign83/img/pc/top.png","https://type.jp/s/campaign83/img/scout.png","https://woman-type.jp/s/renewal/pc/img/top/191105_u29.png"],
        "job":"SE/RPAやAI,loT関連案件など",
        "price":"400~900",
        "special":"850",
        "area":"東京都23区、東京都（２３区を除く）、神奈川県（横浜市、川崎市を除く）、横浜市、川崎市、埼玉県、千葉県、福岡県",
        "company":"株式会社キャリアデザインITパートナーズ「type IT派遣」※(株)キャリアデザインセンター100%出費",
        "period_start":"",
        "period_end":"2020/02/26",
        "tags":["高度成長企業","急募求人","服装自由","英語活かせる","駅から徒歩５分","管理職採用","産休育休実績あり",],
        "main_title":"RPA,AI,loT関連プロジェクトや、大手メーカのーのR&D・・・\nこれから成長する若手こそ、案件にこだわろう。",
        "main_article":"◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n◆◆◆◆\n",
        "salary_exampl":"■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n■２５歳サブリーダー／年収４００万円\n",
    ]

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
        // メイン画像
        self.detailTableView.registerNib(nibName: "JobDetailDataCell", idName: "JobDetailDataCell")
        /// section 1
        // 記事
        self.detailTableView.registerNib(nibName: "JobDetailArticleCell", idName: "JobDetailArticleCell")
        /// section 2
        // PRコード
        // 給与例
        /// section 3
        // 募集要項
        /// section 4
        // 取材メモ
        /// section 5
        // 選考プロセス
        /// section 6
        // 連絡先
        /// section 7
        // 会社概要
        /// section 8
        // 応募ボタン/キープのボタン
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
}

extension JobOfferDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                return 700
            default:
                return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 1:
                // TODO:閉じているときと開いている時でサイズが違う
                return 60
            case 2:
                return 60
            default:
                return 0
        }
    }
}

extension JobOfferDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 1:
                // メイン記事タイトル
                let view = UINib(nibName: "JobDetailArticleHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailArticleHeaderView
                let articleTitle = dummyData["main_title"] as! String
                view.setup(string: articleTitle)
                return view
            case 2:
                // 募集要項
                let view = UINib(nibName: "JobDetailGuideBookHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailGuideBookHeaderView
                return view
            default:
                return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch (section,row) {
            case (0,0):
                let cell = tableView.loadCell(cellName: "JobDetailDataCell", indexPath: indexPath) as! JobDetailDataCell
                cell.setCellWidth(width: self.detailTableView.frame.size.width)
                cell.setup(data: dummyData)
                return cell
            case (0,1):
                let cell = tableView.loadCell(cellName: "JobDetailArticleCell", indexPath: indexPath) as! JobDetailArticleCell
                return cell
            case (1,0):
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.init(colorType: .color_base)
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
        let sectionHeaderHeight = self.detailTableView.sectionHeaderHeight
        let offsetY = scrollView.contentOffset.y
        
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
    }
    
    func appImportantAction() {
        buttonsView.colorChange(no:1)
    }
    
    func employeeAction() {
        buttonsView.colorChange(no:2)
    }
    
    func informationAction() {
        buttonsView.colorChange(no:3)
    }
    
    
}
