//
//  BaseJobCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

protocol BaseJobCardCellDelegate {
    func skipAction(jobId:String)
    func keepAction(jobId:String, newStatus: Bool)
}

class ScoutNoticeView: UIView {
    @IBOutlet weak var mark:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class BaseJobCardCell: BaseTableViewCell {
    
    @IBOutlet weak var spaceView:UIView!
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var thumbnailImageBackView:UIView!
    @IBOutlet weak var thumnailImageView:UIImageView!       // サムネイル
    @IBOutlet weak var limitedMarkBackView:UIView!          // 終了間近View
    @IBOutlet weak var limitedMarkView:UIView!              // 終了間近マーク
    @IBOutlet weak var limitedImageView:UIImageView!        // 期限ImageView
    @IBOutlet weak var limitedLabel:UILabel!                // 終了間近テキスト
    
    @IBOutlet weak var scoutNoticeView:ScoutNoticeView!
    
    @IBOutlet weak var jobView:UIView!
    @IBOutlet weak var jobLabel:UILabel!
    @IBOutlet weak var saralyView:UIView!
    @IBOutlet weak var saralyLabel:UILabel!
    @IBOutlet weak var saralyMarkLabel:UILabel!
    @IBOutlet weak var saralySpecialLabel:UILabel!
    @IBOutlet weak var saralySpecialMarkLabel:UILabel!
    @IBOutlet weak var cautionView:UIView!
    @IBOutlet weak var saralyCautionLabel:UILabel!
    
    @IBOutlet weak var areaView:UIView!
    @IBOutlet weak var areaLabel:UILabel!
    @IBOutlet weak var companyView:UIView!
    @IBOutlet weak var companyNameLabel:UILabel!
    @IBOutlet weak var catchView:UIView!
    @IBOutlet weak var catchLabel:UILabel!
    
    @IBOutlet weak var btnTopSpaceView:UIView!
    
    @IBOutlet weak var btnView:UIView!
    @IBOutlet weak var deleteBtn:UIButton!
    @IBAction func deleteBtnAction() {
//        Log.selectLog(logLevel: .debug, "deleteBtnAction start")
        self.delegate.skipAction(jobId: self.jobCardData.jobCardCode)
    }
    
    // エントリー済
    @IBOutlet weak var entryCompleteImage:UIImageView!
    
    var delegate:BaseJobCardCellDelegate!
    var jobCardData:MdlJobCard!

    override func awakeFromNib() {
        super.awakeFromNib()
        deleteBtn.isExclusiveTouch = true
        spaceView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func changeKeepStatus() {
//    }

}
