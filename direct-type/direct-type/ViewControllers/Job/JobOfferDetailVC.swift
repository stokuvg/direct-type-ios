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
        "salary_example":"■２５歳サブリーダー／年収４００万円\n■２８歳PL／年収４８０万円\n■３０歳PM／年収５５０万円\n■３２歳PM／年収５８０万円\n■３５歳PM／年収６５０万円\n■４０歳マネージャー／年収７４０万円\n■４５歳部長／年収８００万円\n",
        "guidebook":[
            // 1.募集背景:       必須
            ["title":"募集背景",
             "indispensable":"ここに募集背景の必須項目内容を表示",    // 必須項目
                "optional":[],      // 任意項目
                "attention":[],
            ],
            // 2.仕事内容:       必須
            // ・案件例:        任意
            // ・手掛ける商品・サービス:  任意
            // ・開発環境・業務範囲:   任意
            // ・注目ポイント:      任意
            ["title":"仕事内容",
            "indispensable":"多種多様なプロジェクトの中から、あなたの経験や希望に応じた案件で活躍していただきます。\n",    // 必須項目
            "optional":[],      // 任意項目
            // 注目
            "attention":[
                ["title":"希望を吸い上げる風土だから、理想のキャリアパスを描きやすい","text":"当社では、基本的にユニット（チーム体制）でのプロジェクト配属になっており、四半期に1回面談を実施し、ユニット長がここの希望を吸い上げいます。"],
                ["title":"明確な評価制度【充実のインセンティブ/若手も大幅昇給可能】","text":"評価を行うのは、ここの頑張りや実力を一番近くで目にしているユニット長なので、納得感のある評価を得られます。"],
            ]
            ],
            // 3.応募資格:       必須
            // ・歓迎する経験・スキル:   任意
            // ・過去の採用例:      任意
            // ・この仕事の向き・不向き: 任意
            ["title":"応募資格",
            "indispensable":"",    // 必須項目
            "optional":[
                ["title":"歓迎する経験・スキル","text":"⭐︎リーダーを目指したい方、あるいはPM/PL経験者は、大歓迎です！"],
                ["title":"過去の採用例","text":""],
                ["title":"この仕事の向き・不向き","text":"向いている人\n新しいことにチャレンジしながら、理想のキャリアパスを実現したい方には向いてます。\n向いてない人\n現状維持を望む方や、意欲が乏しい方には、合わないかもしれません。"],
                ],      // 任意項目
                "attention":[],
            ],
            // 4.雇用携帯:    必須
            ["title":"雇用形態",
            "indispensable":"正社員",    // 必須項目
            "optional":[],      // 任意項目
            "attention":[],
            ],
            // 5.給与:        必須
            // ・賞与について:     任意
            ["title":"給与",
            "indispensable":"",    // 必須項目
            "optional":[],      // 任意項目
            "attention":[],
            ],
            // 6.勤務時間:       必須
            //  ・残業について:
            ["title":"勤務時間",
            "indispensable":"09:00~18:00(実動８時間)",    // 必須項目
                "optional":[["title":"残業について","text":"月の平均残業時間は10〜20時間程度です。\n1日に換算すると1日30分〜１時間程度になります。\n当社は働き方改革が叫ばれる以前から残業を抑える取り組みをしており、\n労務上の観点から20時間以内になるように指示しています。\nその結果、20時以降社内に残る社員はほどんどいません。"]],      // 任意項目
                "attention":[],
            ],
            // 7.勤務地:       必須
            //  ・交通詳細
            ["title":"勤務地",
            "indispensable":"",    // 必須項目
            "optional":[],      // 任意項目
            "attention":[],
            ],
            // 8.休日休暇:      必須
            ["title":"休日休暇",
            "indispensable":"",    // 必須項目
            "optional":[],      // 任意項目
            "attention":[],
            ],
            // 9.待遇・福利厚生:    必須
            // ・産休・育休取得:   任意
            ["title":"待遇・福利厚生",
            "indispensable":"◆昇給年1回\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n◆\n\n《各種手当て》\n・時間外手当\n・管理職手当(ユニット長:10万円,部長:20万円)\n・通勤手当(課税対象免状限度額を上限とする)",    // 必須項目
            "optional":[],      // 任意項目
            "attention":[],
            ],
        ],
        "folding":[
            "memo":
            [
                "title":"取材メモ",
                "text":"ここにテキストを入れる\n\nここにテキストを入れる",
            ],
            "process":
            [
                "title":"選考プロセス",
                "steps":[
                    ["title":"step1","text":"Web応募による書類選考"],
                    ["title":"step2","text":"面談（１〜２回）※面談は１回のケースが多いですが、場合によって２回になる可能性もあります。"],
                    ["title":"step3","text":"内定"],
                    ["title":"step4","text":"Web応募による書類選考"],
                    ["title":"step5","text":"Web応募による書類選考"],
                ],
                "text1":"【type】の専用応募フォームからご応募ください。\n※ご応募については秘密厳守いたします。\n※\n※\n\n",
                "text2":"----------------------------\n当求人案件は株式会社キャリアデザインセンターが運営する株式会社システムソフト type採用事務局にて応募の受付業務を代行しております。",
            ],
            "phone_number":
            [
                "title":"連絡先",
                "url":"http://www.systemsoft.co.jp/",
                "zipcode":"100-0004",
                "address":"東京都千代田区大手町二丁目６番１号 朝日生命大手町ビル２階",
                "tel":"03-6261-4536",
                "person":"採用担当",
                "email":"saiyo@systemsoft.co.jp",
            ],
            "outline":
            [
                "title":"会社概要",
                "Description":["title":"事業内容","item":"■WEBアプリの企画・開発・導入支援\n■スマホ・タブレットアプリの企画・開発・導入支援\n■システムコンサルテーション事業\n■ソフトウェアパッケージの開発・販売・導入支援\n■サーバ・ネットワーク設計・構築・運用管理サービスの提供\n■アウトソーシング\n"],                                                      // 必須
                "clients":["title":"主要取引先","names":"青葉出版(株)\n(株)オープンハウス・ディベロップメント\n(株)CSEビジテック\n(株)\n(株)\n(株)"],                                                     // 任意
                "media":["title":"事業・サービスのメディア掲載実績","items":"明治大学博物館\nユニバーサルコンピューター(株)"],                                   // 任意
                "establishment":["title":"設立","items":"1996年12月"],                                                         // 任意
                "employees":["title":"従業員数","employees":"132名(技術者118名)","average":"３２歳","ratio":"","halfway":"約５割"],   // 任意
                "capital":["title":"資本金","results":"20,000,000円"],                                                       // 任意
                "sales":["title":"売上高","results":"14億円(2018年11月実績)"],                                                       // 任意
                "representative":["title":"代表者","name":"代表取締役社長　峯岸 正積","career":"1979年11月5日生まれ。2002年コニカミノルタ株式会社に入社。"],                                     // 任意
            ],
        ],
    ]
    
    var articleOpenFlag:Bool = false
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
        // 1.募集背景:              必須
        // 2.仕事内容:              必須
        // 　・案件例:               任意
        // 　・手掛ける商品・サービス:   任意
        // 　・開発環境・業務範囲:     任意
        // 　・注目ポイント:           任意
        // 3.応募資格:              必須
        // 　・歓迎する経験・スキル:     任意
        // 　・過去の採用例:           任意
        // 　・この仕事の向き・不向き:  任意
        // 4.雇用携帯コード:        必須
        // 5.給与:               必須
        // 　・賞与について:          任意
        // 6.勤務時間:             必須
        //   ・残業について:
        // 7.勤務地:              必須
        //   ・交通詳細
        // 8.休日休暇:            必須
        // 9.待遇・福利厚生:       必須
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
        switch section {
            case 1:
                return articleOpenFlag ? 120 : 60
            case 3:
                return 60
            case 4,5,6,7:
                return 55
            default:
                return 0
        }
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
                let articleTitle = dummyData["main_title"] as! String
                view.setup(string: articleTitle,openFlag: articleOpenFlag)
                return view
            case 3:
                // 募集要項
                let view = UINib(nibName: "JobDetailGuideBookHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailGuideBookHeaderView
                return view
            case 4,5,6,7:
                // 取材メモ
                // 選考プロセス
                // 連絡先
                // 会社概要
                let view = UINib(nibName: "JobDetailFoldingHeaderView", bundle: nil)
                    .instantiate(withOwner: self, options: nil)
                    .first as! JobDetailFoldingHeaderView
                view.delegate = self
                let foldingDatas = dummyData["folding"] as! [String: Any]
                view.tag = (section - foldingDatas.count)
                
                var openFlag:Bool = false
                var keyName:String = ""
                switch section {
                    case 4:
                        openFlag = coverageMemoOpenFlag
                        keyName = "memo"
                    case 5:
                        openFlag = selectionProcessOpenFlag
                        keyName = "process"
                    case 6:
                        openFlag = phoneNumberOpenFlag
                        keyName = "phone_number"
                    case 7:
                        openFlag = companyOutlineOpenFlag
                        keyName = "outline"
                    default:
                        openFlag = false
                        keyName = ""
                }
                let foldingData = foldingDatas[keyName] as! [String:Any]
                
                let title = foldingData["title"] as! String
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
                return 9
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
                cell.setup(data: dummyData)
                return cell
            case (0,1):
                let cell = tableView.loadCell(cellName: "JobDetailImageCell", indexPath: indexPath) as! JobDetailImageCell
                cell.setCellWidth(width: self.detailTableView.frame.size.width)
                cell.setup(data: dummyData)
                return cell
            case (1,0):
                if articleOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailArticleCell", indexPath: indexPath) as! JobDetailArticleCell
                    cell.delegate = self
                    if articleOpenFlag {
                        let articleString = dummyData["main_article"] as! String
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
                let datas = dummyData["tags"] as! [String]
                cell.setup(datas: datas)
                return cell
            case (2,1):
                let cell = tableView.loadCell(cellName: "JobDetailSalaryExampleCell", indexPath: indexPath) as! JobDetailSalaryExampleCell
                let examples = dummyData["salary_example"] as! String
                cell.setup(data: examples)
                return cell
            case (3,_):
                let guideBookData = dummyData["guidebook"] as! [[String:Any]]
                let itemData = guideBookData[row]
                let cell = tableView.loadCell(cellName: "JobDetailItemCell", indexPath: indexPath) as! JobDetailItemCell
                cell.setup(data: itemData)
                return cell
            case (4,_):
                if coverageMemoOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingMemoCell", indexPath: indexPath) as! JobDetailFoldingMemoCell
                    
                    let foldingDatas = dummyData["folding"] as! [String: Any]
                    let foldingData = foldingDatas["memo"] as! [String: Any]
                    let memoText = foldingData["text"] as! String
                    cell.setup(data: memoText)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (5, _):
                if selectionProcessOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingProcessCell", indexPath: indexPath) as! JobDetailFoldingProcessCell
                    let foldingDatas = dummyData["folding"] as! [String: Any]
                    let foldingData = foldingDatas["process"] as! [String: Any]
                    
                    cell.setup(data: foldingData)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (6, _):
                if phoneNumberOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingPhoneNumberCell", indexPath: indexPath) as! JobDetailFoldingPhoneNumberCell
                    let foldingDatas = dummyData["folding"] as! [String: Any]
                    let foldingData = foldingDatas["phone_number"] as! [String: Any]
                    
                    cell.setup(data: foldingData)
                    return cell
                } else {
                    return UITableViewCell()
                }
            case (7, _):
                if companyOutlineOpenFlag {
                    let cell = tableView.loadCell(cellName: "JobDetailFoldingOutlineCell", indexPath: indexPath) as! JobDetailFoldingOutlineCell
                    let foldingDatas = dummyData["folding"] as! [String: Any]
                    let foldingData = foldingDatas["outline"] as! [String: Any]
                    
                    cell.setup(data: foldingData)
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
        
        let section = 3
        let titleName = "仕事内容"
        self.guidebookScrollAnimation(section: section,titleName: titleName)
    }
    
    func appImportantAction() {
        buttonsView.colorChange(no:1)
        
        let section = 3
        let titleName = "応募資格"
        self.guidebookScrollAnimation(section: section,titleName: titleName)
    }
    
    func employeeAction() {
        buttonsView.colorChange(no:2)
        
        let section = 3
        let titleName = "待遇"
        self.guidebookScrollAnimation(section: section,titleName: titleName)
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
    
    func guidebookScrollAnimation(section:Int, titleName:String) {
        let guidebookData = dummyData["guidebook"] as! [[String:Any]]
        
        var row:Int = 0
        for i in 0..<guidebookData.count {
            let data = guidebookData[i]
            if let keyName:String = (data["title"] as! String) {
                if keyName.hasPrefix("待遇") {
                    row = i
                    break
                }
            }
        }
        
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
        
        let foldingDatas = dummyData["folding"] as! [String: Any]
        
        let section = foldingDatas.count + tag
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
    
    func footerKeepBtnAction() {
        // キープ情報送信
    }
}
