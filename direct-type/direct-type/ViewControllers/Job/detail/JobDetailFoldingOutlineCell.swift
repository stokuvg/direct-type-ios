//
//  JobDetailFoldingOutlineCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingOutlineCell: BaseTableViewCell {
    
    @IBOutlet weak var stackView:UIStackView!
    
    @IBOutlet weak var descriptionTitle:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for subView in self.stackView.subviews {
            if subView is JobDetailFoldingOptionalView {
                subView.removeFromSuperview()
            }
        }
    }
    
    func setup(data:[String: Any]) {
        Log.selectLog(logLevel: .debug, "JobDetailFoldingOutlineCell data start")
        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        let descriptionData = data["Description"] as! [String: Any]
        Log.selectLog(logLevel: .debug, "descriptionData:\(descriptionData)")
        let title = descriptionData["title"] as! String
        let item = descriptionData["item"] as! String
        
        descriptionTitle.text(text: title, fontType: .C_font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        descriptionLabel.text(text: item, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 任意
        /*
        "clients":["title":"主要取引先","names":""],                                                     // 任意
        "media":["title":"事業・サービスのメディア掲載実績","items":""],                                   // 任意
        "establishment":["title":"設立","items":""],                                                         // 任意
        "employees":["title":"従業員数","employees":"","average":"","ratio":"","halfway":""],   // 任意
        "capital":["title":"資本金","results":""],                                                       // 任意
        "sales":["title":"売上高","results":""],                                                       // 任意
        "representative":["title":"代表者","name":"","career":""],                                     // 任意
         */
        let clients = data["clients"] as! [String: Any]
        self.makeClientsView(data: clients)
        
        let media = data["media"] as! [String: Any]
        self.makeMediaView(data: media)
        
        let establishment = data["establishment"] as! [String: Any]
        self.makeEstablishmentView(data: establishment)
        
        let employees = data["employees"] as! [String: Any]
        self.makeEmployeesView(data: employees)
        
        let capital = data["capital"] as! [String: Any]
        self.makeCapitalView(data: capital)
        
        let sales = data["sales"] as! [String: Any]
        self.makeSalesView(data: sales)
        
        let representative = data["representative"] as! [String: Any]
        self.makeRepresentativeView(data: representative)
        
        self.makeSpaceView()
    }
    
    // 取引先
    private func makeClientsView(data:[String: Any]) {
        let title = data["title"] as! String
        let names = data["names"] as! String
        
        if names.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: names)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // メディア
    private func makeMediaView(data:[String: Any]) {
        let title = data["title"] as! String
        let items = data["items"] as! String
        
        if items.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: items)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 設立
    private func makeEstablishmentView(data:[String: Any]) {
        let title = data["title"] as! String
        let items = data["items"] as! String
        
        if items.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: items)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 従業員
    private func makeEmployeesView(data:[String: Any]) {
        let title = data["title"] as! String
        let employees = data["employees"] as! String
        
        if employees.count > 0 {
            var text = employees
            
            let average = data["average"] as! String
            let ratio = data["ratio"] as! String
            let halfway = data["halfway"] as! String
            
            if average.count > 0 {
                text = text + "\n" + "平均年齢／" + average
            }
            
            if ratio.count > 0 {
                text = text + "\n" + "男女比／" + average
            }
            
            if halfway.count > 0 {
                text = text + "\n" + "中途入社者の割合／" + halfway
            }
            
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: text)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 資本金
    private func makeCapitalView(data:[String: Any]) {
        let title = data["title"] as! String
        let results = data["results"] as! String
        
        if results.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: results)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 売上高
    private func makeSalesView(data:[String: Any]) {
        let title = data["title"] as! String
        let results = data["results"] as! String
        
        if results.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: results)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 代表
    private func makeRepresentativeView(data:[String: Any]) {
        let title = data["title"] as! String
        let name = data["name"] as! String
        let carrer = data["career"] as! String
        
        if name.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            
            var text = name
            if carrer.count > 0 {
                text = text + "\n"
                text = text + "【略歴】" + "\n"
                text = text + carrer
            }
            
            view.setup(title: title, item: text)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    
    // スペース
    private func makeSpaceView() {
        let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
        .instantiate(withOwner: self, options: nil)
        .first as! JobDetailFoldingOptionalView
        
        view.setup(title: "", item: "")
        
        self.stackView.addArrangedSubview(view)
    }
}
