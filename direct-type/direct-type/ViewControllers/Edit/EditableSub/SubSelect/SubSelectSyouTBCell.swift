//
//  SubSelectSyouTBCell.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/23.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

class SubSelectSyouTBCell: UITableViewCell {
    var delegate: SubSelectProtocol!

    var item: CodeDisp!
    var subItem: CodeDisp? = nil
    var focus: Bool = false
    
    @IBOutlet weak var vwCellArea: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDebug: UILabel!

    @IBOutlet weak var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwCellArea.backgroundColor = UIColor(colorType: .color_base)
    }
    //== セルの初期化と初期表示
    func initCell(_ delegate: SubSelectProtocol, _ item: CodeDisp, _ subItem: CodeDisp? = nil, _ focus: Bool = false) {
        self.delegate = delegate
        self.item = item
        self.subItem = subItem
        self.focus = focus
        if Constants.DbgDispStatus {
            self.lblDebug.isHidden = false
        } else {
            self.lblDebug.isHidden = true
        }
    }
    func dispCell() {
        lblName.text(text: item.disp, fontType: .font_S, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        if Constants.DbgDispStatus {
            self.lblDebug.text = "\(item.debugDisp): \(subItem?.debugDisp ?? "nil")"
        }
        if let subItem = subItem {
            lblStatus.text = subItem.disp
        } else {
            lblStatus.text = ""
        }
        if let _ = subItem {
            vwCellArea.backgroundColor = UIColor(colorType: .color_sub)
            lblName.textColor = .white
            lblStatus.textColor = .white
        } else {
            vwCellArea.backgroundColor = .white
            lblName.textColor = .black
            lblStatus.textColor = .black
            if focus {
                vwCellArea.backgroundColor = UIColor(colorType: .color_specialItemFocus)
            }
        }

    }
    //=== 選択時の動作
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        dispCell()
    }
}



