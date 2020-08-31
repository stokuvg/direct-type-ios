//
//  SubSelectDaiTBCell.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/23.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

class SubSelectDaiTBCell: UITableViewCell {
    var delegate: SubSelectProtocol!

    var item: CodeDisp!
    var selectStatus: Bool = false
    var arrSelChild: [Code] = []
    
    @IBOutlet weak var vwCellArea: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDebug: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var ivStatus: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwCellArea.backgroundColor = UIColor(colorType: .color_base)
    }
    //== セルの初期化と初期表示
    func initCell(_ delegate: SubSelectProtocol, _ item: CodeDisp, _ selected: Bool = false, _ arrSelChild: [Code]) {
        self.delegate = delegate
        self.item = item
        self.selectStatus = selected
        self.arrSelChild = arrSelChild
        if Constants.DbgDispStatus {
            self.lblDebug.isHidden = false
        } else {
            self.lblDebug.isHidden = true
        }
    }
    func dispCell() {
        lblName.text(text: item.disp, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        if Constants.DbgDispStatus {
            self.lblDebug.text = "\(selectStatus ? "●" : "・"): \(item.debugDisp)"
        }
        if selectStatus {//開いてる
            ivStatus.image = R.image.arTop()
        } else {
            ivStatus.image = R.image.arBtm_2()
        }
        if arrSelChild.count > 0 {
            lblCount.text = "(\(arrSelChild.count)件)"
        } else {
            lblCount.text = ""
        }
    }
    //=== 選択時の動作
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        dispCell()
    }
}


