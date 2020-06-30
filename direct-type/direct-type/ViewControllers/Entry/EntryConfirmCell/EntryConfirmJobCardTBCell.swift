//
//  EntryConfirmJobCardTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryConfirmJobCardTBCell: UITableViewCell {
    var jobCard: MdlJobCardDetail? = nil

    @IBOutlet weak var vwBoardArea: UIView!
    @IBOutlet weak var vwBoardSafeArea: UIView!

    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwHeadArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwStackArea: UIView!
    @IBOutlet weak var stackVW: UIStackView!
    @IBOutlet weak var vwFootArea: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)
        vwBoardArea.backgroundColor = .white
        vwBoardArea.cornerRadius = 16
        vwBoardArea.clipsToBounds = true
        vwBoardArea.borderColor = UIColor(colorType: .color_line)!
        vwBoardArea.borderWidth = 1
    }
    func initCell(_ model: MdlJobCardDetail?) {
        self.jobCard = model
    }
    func dispCell() {
        guard let _jobCard = self.jobCard else { return }
        
        lblTitle.text(text: "", fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        //=== 既存部品の全削除
        for asv in stackVW.arrangedSubviews {
            stackVW.removeArrangedSubview(asv)
            asv.removeFromSuperview()
        }
        //=== 表示項目を追加していく
        let bufCompanyName = _jobCard.companyName
        let bufJobName = _jobCard.jobName
        let endDate = DateHelper.convStrYMD2Date(_jobCard.end_date)
        let bufDate = "〜\(endDate.dispYmdJP())"
        stackVW.addArrangedSubview(EntryConfirmItem("会社名", "\(bufCompanyName)"))
        stackVW.addArrangedSubview(EntryConfirmItem("仕事名", "\(bufJobName)\(bufJobName)\(bufJobName)\(bufJobName)\(bufJobName)\(bufJobName)"))
        stackVW.addArrangedSubview(EntryConfirmItem("仕事名", "\(bufJobName)"))
        stackVW.addArrangedSubview(EntryConfirmItem("仕事名", "\(bufJobName)"))
        stackVW.addArrangedSubview(EntryConfirmItem("応募期限", "\(bufDate)"))
        stackVW.addArrangedSubview(EntryConfirmItem("応募期限", "\(bufDate)"))
        stackVW.addArrangedSubview(EntryConfirmItem("応募期限", "\(bufDate)"))
        //すべてを表示させる
        for asv in stackVW.arrangedSubviews {
            if let eci = asv as? EntryConfirmItem {
                print(eci.bounds)
                eci.setNeedsLayout()
                eci.sizeToFit()
                eci.dispCell()
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
