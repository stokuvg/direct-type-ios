//
//  JobDetailFoldingOutlineCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

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
    
    func setup(data: JobCardDetailCompanyDescription) {
//        Log.selectLog(logLevel: .debug, "JobDetailFoldingOutlineCell data start")
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        let title = data.enterpriseContents.title
        let item = data.enterpriseContents.text
        
        descriptionTitle.text(text: title!, fontType: .C_font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        descriptionLabel.text(text: item!, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let clients = data.mainCustomer
        self.makeClientsView(data: clients)
        
        let media = data.mediaCoverage
        self.makeMediaView(data: media)
        
        let establishment = data.established
        self.makeEstablishmentView(data: establishment)
        
        let employees = data.employeesCount
        self.makeEmployeesView(data: employees)
        
        let capital = data.capital
        self.makeCapitalView(data: capital!)
        
        let sales = data.turnover
        self.makeSalesView(data: sales!)
        
        let representative = data.presidentData
        self.makeRepresentativeView(data: representative)
    }
    
    // 取引先
    private func makeClientsView(data: JobCardDetailCompanyDescriptionMainCustomer) {
        let title = data.title
        let names = data.text
        
        if names!.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title!, item: names!)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // メディア
    private func makeMediaView(data: JobCardDetailCompanyDescriptionMediaCoverage) {
        let title = data.title!
        let text = data.text!
        
        if text.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: text)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    
    // 設立
    private func makeEstablishmentView(data: JobCardDetailCompanyDescriptionEstablished) {
        
        let title = data.title!
        let items = data.text!
        
        if items.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: items)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    
    // 従業員
    private func makeEmployeesView(data: JobCardDetailCompanyDescriptionEmployeesCount){
        let title = data.title!
        let employees = data.count!
        
        if employees.count > 0 {
            var text = employees
            
            let average = data.averageAge!
            let ratio = data.genderRatio!
            let halfway = data.middleEnter!
            
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
    private func makeCapitalView(data: JobCardDetailCompanyDescriptionCapital) {
        let title = data.title!
        let results = data.text!
        
        if results.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: results)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 売上高
    private func makeSalesView(data: JobCardDetailCompanyDescriptionTurnover) {
        let title = data.title!
        let results = data.text!
        
        if results.count > 0 {
            let view = UINib.init(nibName: "JobDetailFoldingOptionalView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailFoldingOptionalView
            view.setup(title: title, item: results)
            
            self.stackView.addArrangedSubview(view)
        }
    }
    // 代表
    private func makeRepresentativeView(data: JobCardDetailCompanyDescriptionPresidentData) {
        let title = data.title!
        let name = data.presidentName!
        let carrer = data.presidentHistory
        
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
}
