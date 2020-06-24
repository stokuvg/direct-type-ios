//
//  EntryFormJobCardTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormJobCardTBCell: UITableViewCell {
    var model: MdlJobCardDetail? = nil
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        self.backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
    }
    func initCell(_ model: MdlJobCardDetail?) {
        self.model = model
    }
    
    func dispCell() {
        guard let _model = self.model else { return }
        let bufCompanyName = _model.companyName
        let bufJobName = _model.jobName
        let bufDate = Date().dispYmdJP()
        lblTitle.text(text: "応募先", fontType: .font_Sb, textColor: .black, alignment: .center)
        lblCompanyName.text(text: bufCompanyName, fontType: .font_Sb, textColor: .black, alignment: .left)
        lblJobTitle.text(text: bufJobName, fontType: .font_Sb, textColor: .black, alignment: .left)
        lblDate.text(text: bufDate, fontType: .font_SS, textColor: .black, alignment: .right)
    }
            
            
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
