//
//  CareerCardTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol CareerCardTBCellDelegate {
    func selectCareerCard(num: Int, card: MdlCareerCard)
    func deleteCareerCard(num: Int, card: MdlCareerCard)
}

class CareerCardTBCell: UITableViewCell {
    var delegate: CareerCardTBCellDelegate? = nil
    
    var targetCardNum: Int = 0 //編集対象のカード番号
    var item: MdlCareerCard? = nil
    
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var stackVW: UIStackView!

    //===職歴書カードを削除する（これはカードごとにボタンつける？）
    @IBOutlet weak var btnDelCard: UIButton!
    @IBAction func actDelCard(_ sender: UIButton) {
        guard let _item = item else { return }
        delegate?.deleteCareerCard(num: targetCardNum, card: _item)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
    }
    
    func initCell(_ delegate: CareerCardTBCellDelegate, pos: Int, _ item: MdlCareerCard) {
        self.delegate = delegate
        self.targetCardNum = pos
        self.item = item
        //===ひとつめは削除不可
        self.btnDelCard.isHidden = (pos == 0) ? true : false
    }
    
    func dispCell() {
        guard let career = item else { return }
        //===表示用文字列の生成
        let bufTitle: String = "\(targetCardNum + 1)社目"
        let bufDetail: String = career.debugDisp
        //在籍企業概要
        var dispCompany: [String] = []
        if !career.companyName.isEmpty { dispCompany.append(career.companyName) }
        if (Int(career.employeesCount) ?? 0) > 0 { dispCompany.append("従業員数\(career.employeesCount)名") }

        if let buf = SelectItemsManager.getCodeDisp(.employmentType, code: career.employmentType) {
            dispCompany.append(buf.disp)
        }

        //===表示させる
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        lblTitle.updateConstraints()

        //=== 既存部品の全削除
        for asv in stackVW.arrangedSubviews {
            stackVW.removeArrangedSubview(asv)
            asv.removeFromSuperview()
        }
        //=== 表示項目を追加していく
        stackVW.addArrangedSubview(EntryConfirmItem("職務経歴詳細", bufDetail))
        if dispCompany.count > 0 {
            stackVW.addArrangedSubview(EntryConfirmItem("在籍企業概要", dispCompany.joined(separator: "\n")))
        }
        //すべてを表示させる
        for asv in stackVW.arrangedSubviews {
            if let eci = asv as? EntryConfirmItem {
                eci.dispCell()
                eci.updateConstraints()
            }
        }
        stackVW.sizeToFit()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
