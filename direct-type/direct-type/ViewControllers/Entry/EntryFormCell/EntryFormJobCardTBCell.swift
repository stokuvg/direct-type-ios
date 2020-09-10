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
    var isFullDisp: Bool = false
    
    @IBOutlet weak 	var vwMainArea: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
        selectionStyle = .none
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_white)//xcode11だと無視されるがxcode12だと適用される
    }
    func initCell(_ model: MdlJobCardDetail?, isFullDisp: Bool = false) {
        self.model = model
        self.isFullDisp = isFullDisp
        lblJobTitle.numberOfLines = isFullDisp ? 0 : 2
    }
    
    func dispCell() {
        guard let _model = self.model else { return }
        let bufCompanyName = _model.companyName
        let bufJobName = _model.jobName
        let endDate = DateHelper.convStrYMD2Date(_model.end_date)
        let bufDate = "応募期限：〜\(endDate.dispYmdJP())"
        lblTitle.text(text: "応募先", fontType: .E_font_Mb, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        lblCompanyName.text(text: bufCompanyName, fontType: .E_font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
        lblJobTitle.text(text: bufJobName, fontType: .E_font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblDate.text(text: bufDate, fontType: .E_font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .right)
    }
            
            
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
