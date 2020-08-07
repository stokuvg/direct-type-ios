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
    var dispDelBtn: Bool = true
    
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
    
    func initCell(_ delegate: CareerCardTBCellDelegate, pos: Int, _ item: MdlCareerCard, _ dispDelBtn: Bool = true) {
        self.delegate = delegate
        self.targetCardNum = pos
        self.item = item
        self.dispDelBtn = dispDelBtn
    }
    
    func dispCell() {
        self.btnDelCard.isHidden = !dispDelBtn //===最後のひとつは削除不可
        guard let career = item else { return }
        //===表示用文字列の生成
        let bufTitle: String = "勤務先\(targetCardNum + 1)"
        //===在籍企業概要
        var dispCompany: [String] = []
        if !career.companyName.isEmpty { dispCompany.append(career.companyName) }
        if (Int(career.employeesCount) ?? 0) > 0 { dispCompany.append("従業員数\(career.employeesCount)名") }
        //=雇用期間
        let bufWorkPeriodStart = career.workPeriod.startDate.dispYmJP()
        var bufWorkPeriodEnd: String = ""
        if career.workPeriod.endDate == Constants.DefaultSelectWorkPeriodEndDate {
            bufWorkPeriodEnd = Constants.DefaultSelectWorkPeriodEndDateJP
        } else {
            bufWorkPeriodEnd = career.workPeriod.endDate.dispYmJP()
        }
        var bufWorkPeriod: String = "\(bufWorkPeriodStart)〜\(bufWorkPeriodEnd)"
        //何年何か月を求める
        let tmpStart = career.workPeriod.startDate
        var tmpEnd = career.workPeriod.endDate
        if tmpEnd == Constants.DefaultSelectWorkPeriodEndDate {
            tmpEnd = Date()//「就業中」の場合には、「今日」で計算する
        }
        if tmpStart != Constants.SelectItemsUndefineDate { //開始が未定義なら計算対象外
            let period = Calendar.current.dateComponents([.year, .month], from: tmpStart, to: tmpEnd)
            let tmpPeriodY = period.year ?? 0
            let tmpPeriodM = (period.month ?? 0)
            //let tmpPeriodM = (period.month ?? 0) + 1 //当月を1ヶ月とする場合
            let bufPeriodY: String = (tmpPeriodY == 0) ? "" : "\(tmpPeriodY)年"
            let bufPeriodM: String = (tmpPeriodM == 0) ? "" : "\(tmpPeriodM)ヶ月"
            if !(bufPeriodY.isEmpty && bufPeriodM.isEmpty) { //どちらも空じゃない場合
                bufWorkPeriod = "\(bufWorkPeriod)（\(bufPeriodY)\(bufPeriodM)）"
            }
        }
        dispCompany.append(bufWorkPeriod)
        if let buf = SelectItemsManager.getCodeDisp(.employmentType, code: career.employmentType) {
            dispCompany.append(buf.disp)
        }
        if let buf = SelectItemsManager.getCodeDisp(.salarySelect, code: career.salary) {
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
        if dispCompany.count > 0 {
            stackVW.addArrangedSubview(CareerCardItemVW("在籍企業概要", dispCompany.joined(separator: "\n")))
        }
        if !career.contents.isEmpty {
            stackVW.addArrangedSubview(CareerCardItemVW("職務経歴詳細", career.contents))
        }
        //すべてを表示させる
        for asv in stackVW.arrangedSubviews {
            if let eci = asv as? CareerCardItemVW {
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
