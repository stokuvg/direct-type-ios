//
//  JobDetailFoldingProcessCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class JobDetailFoldingProcessCell: BaseTableViewCell {
    
    @IBOutlet weak var stackView:UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    */

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:JobCardDetailSelectionProcess) {
//    func setup(data:[String: Any]) {
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        let step1 = data.selectionProcess1
        let step2 = data.selectionProcess2
        let step3 = data.selectionProcess3
        let step4 = data.selectionProcess4
        let step5 = data.selectionProcess5
        
        for i in 0..<5 {
            let view = UINib.init(nibName: "JobDetailStepView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailStepView
            
            let stepNo = "step" + String(i)
            
            var text = ""
            switch i {
                case 0:
                    text = step1
                case 1:
                    text = step2
                case 2:
                    text = step3
                case 3:
                    text = step4
                case 4:
                    text = step5
                default:
                    text = step1
            }
            
            view.setup(no: stepNo, text: text)
            
            self.stackView.addArrangedSubview(view)
        }
        
        let detailText = data.selectionProcessDetail
        let view = UINib.init(nibName: "JobDetailTextView", bundle: nil)
        .instantiate(withOwner: self, options: nil)
        .first as! JobDetailTextView
        
        view.setup(data: detailText)
        self.stackView.addArrangedSubview(view)
        
    }
    
}
