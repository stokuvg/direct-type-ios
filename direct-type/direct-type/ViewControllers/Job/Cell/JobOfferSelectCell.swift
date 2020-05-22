//
//  JobOfferSelectCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/22.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobOfferSelectCell: BaseTableViewCell {
    
    @IBOutlet weak var btnView:UIView!
    @IBOutlet weak var deleteBtn:UIButton!
    @IBAction func deleteBtnAction() {
        
    }
    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(skip:Bool, status:Bool) {
        
    }
    
}
