//
//  JobDetailFoldingMemoCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

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
    
    func setup(data: JobCardDetailInterviewMemo) {
//    func setup(data:String) {
        let memoText = data.interviewContent
        self.memoLabel.text(text: memoText, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let memoImageUrlString1 = data.interviewPhoto1
        let memoImageUrlString2 = data.interviewPhoto2
        let memoImageUrlString3 = data.interviewPhoto3
    }
}
