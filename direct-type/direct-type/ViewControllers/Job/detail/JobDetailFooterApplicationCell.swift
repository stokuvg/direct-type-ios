//
//  JobDetailFooterApplicationCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobDetailFooterApplicationCellDelegate {
    func footerApplicationBtnAction()
    func footerKeepBtnAction()
}

class JobDetailFooterApplicationCell: BaseTableViewCell {
    
    @IBOutlet weak var applicationBtn:UIButton!
    @IBAction func applicationBtnAction() {
        self.delegate.footerApplicationBtnAction()
    }
    
    var keepFlag:Bool!
    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        self.delegate.footerKeepBtnAction()
        
        keepFlag = !keepFlag        
        self.keepDataSetting(flag: keepFlag)
    }
    
    var delegate:JobDetailFooterApplicationCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        keepBtn.setTitle(text: "", fontType: .C_font_M, textColor: UIColor.clear, alignment: .center)
        
        keepFlag = false
        self.keepDataSetting(flag: keepFlag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func keepDataSetting(flag:Bool) {
        Log.selectLog(logLevel: .debug, "JobDetailFooterApplicationCell keepDataSetting start")
        Log.selectLog(logLevel: .debug, "flag:\(flag)")
        
        let imageName:String = flag ? "likeSelected" : "likeDefault"
        let btnImage = UIImage(named: imageName)
        keepBtn.setImage(btnImage, for: .normal)
    }
    
}
