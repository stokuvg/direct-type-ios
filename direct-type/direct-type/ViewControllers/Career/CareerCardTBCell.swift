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

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    //===職歴書カードを削除する（これはカードごとにボタンつける？）
    @IBOutlet weak var btnDelCard: UIButton!
    @IBAction func actDelCard(_ sender: UIButton) {
        guard let _item = item else { return }
        delegate?.deleteCareerCard(num: targetCardNum, card: _item)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(_ delegate: CareerCardTBCellDelegate, pos: Int, _ item: MdlCareerCard) {
        self.delegate = delegate
        self.targetCardNum = pos
        self.item = item
    }
    
    func dispCell() {
        guard let _item = item else { return }
        //===表示用文字列の生成
        let bufTitle: String = "職歴書カード\(targetCardNum + 1)"
        let bufDetail: String = _item.debugDisp
        //===表示させる
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        lblDetail.text(text: bufDetail, fontType: .font_S, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
