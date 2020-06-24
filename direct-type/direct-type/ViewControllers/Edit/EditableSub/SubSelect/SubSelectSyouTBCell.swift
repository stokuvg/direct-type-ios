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
    func initCell(_ delegate: SubSelectProtocol, _ item: CodeDisp, _ subItem: CodeDisp? = nil) {
        self.delegate = delegate
        self.item = item
        self.subItem = subItem
        if Constants.DbgDispStatus {
            self.lblDebug.isHidden = false
        } else {
            self.lblDebug.isHidden = true
        }
    }
    func dispCell() {
        self.lblName.text = item.disp
        if Constants.DbgDispStatus {
            self.lblDebug.text = "\(item.debugDisp): \(subItem?.debugDisp ?? "nil")"
        }
        if let subItem = subItem {
            lblStatus.text = subItem.disp
        } else {
            lblStatus.text = ""
        }
        if let _ = subItem { //TODO: 選択、非選択、選択不可（非活性）などに状態を増やす
            vwCellArea.backgroundColor = .red
            lblName.textColor = .white
            lblStatus.textColor = .white
        } else {
            vwCellArea.backgroundColor = .white
            lblName.textColor = .black
            lblStatus.textColor = .black
        }

    }
    //=== 選択時の動作
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        dispCell()
    }
}



