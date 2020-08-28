//
//  JobOfferCardReloadCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobOfferCardReloadCellDelegate {
    func allTableReloadAction()
}

class JobOfferCardReloadCell: BaseTableViewCell {
    @IBOutlet weak var reloadBtn:UIButton!
    @IBAction func reloadAction() {
        self.delegate.allTableReloadAction()
    }
    
    var delegate:JobOfferCardReloadCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        reloadBtn.setTitle(text: "おすすめ求人を更新", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
