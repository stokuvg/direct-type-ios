//
//  JobDetailFoldingMemoCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingMemoCell: BaseTableViewCell {
    
    @IBOutlet weak var memoLabel: UILabel!

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
    
    func setup(data:String) {
        self.memoLabel.text(text: data, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
}
