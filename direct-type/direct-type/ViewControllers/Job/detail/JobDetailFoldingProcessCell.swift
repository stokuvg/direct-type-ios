//
//  JobDetailFoldingProcessCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingProcessCell: BaseTableViewCell {
    
    @IBOutlet weak var stackView:UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String: Any]) {
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        let steps:[[String: Any]] = data["steps"] as! [[String: Any]]
        if steps.count > 0 {
            for step in steps {
                let view = UINib.init(nibName: "JobDetailStepView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailStepView
                
                view.setup(data: step)
                
                self.stackView.addArrangedSubview(view)
            }
        }
        
        let text1:String = data["text1"] as! String
        if text1.count > 0 {
            let view = UINib.init(nibName: "JobDetailTextView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailTextView
            
            view.setup(data: text1)
            self.stackView.addArrangedSubview(view)
        }
        
        let text2:String = data["text2"] as! String
        if text2.count > 0 {
            let view = UINib.init(nibName: "JobDetailTextView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as! JobDetailTextView
            
            view.setup(data: text2)
            self.stackView.addArrangedSubview(view)
        }
        
    }
    
}
