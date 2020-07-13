//
//  SubSelectTBCell.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/22.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

protocol SubSelectProtocol {
}

class SubSelectTBCell: UITableViewCell {
    var delegate: SubSelectProtocol!

    var item: CodeDisp!
    var selectStatus: Bool = false
    var exclusive: Bool = false
    
    @IBOutlet weak var vwCellArea: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwCellArea.backgroundColor = UIColor(colorType: .color_base)
    }
    //== セルの初期化と初期表示
    func initCell(_ delegate: SubSelectProtocol, _ item: CodeDisp, _ selected: Bool = false, _ exclusive: Bool) {
        self.delegate = delegate
        self.item = item
        self.selectStatus = selected
        self.exclusive = exclusive
        if Constants.DbgDispStatus {
            self.lblDebug.isHidden = false
        } else {
            self.lblDebug.isHidden = true
        }
    }
    func dispCell() {
        self.backgroundColor = .yellow
        self.lblName.text = item.disp
        if Constants.DbgDispStatus {
            self.lblDebug.text = "\(selectStatus ? "●" : "・"): \(item.debugDisp)"
        }
        if selectStatus { //TODO: 選択、非選択、選択不可（非活性）などに状態を増やす
            vwCellArea.backgroundColor = UIColor(colorType: .color_sub)
            if exclusive && item.code != SubSelectBaseVC.ExclusiveSelectCode {
                lblName.textColor = UIColor(colorType: .color_light_gray)
            } else {
                lblName.textColor = .white
            }
        } else {
            vwCellArea.backgroundColor = .white
            if exclusive && item.code != SubSelectBaseVC.ExclusiveSelectCode {
                lblName.textColor = UIColor(colorType: .color_light_gray)
            } else {
                lblName.textColor = .black
            }
        }
        if item.code != SubSelectBaseVC.ExclusiveSelectCode {
            isUserInteractionEnabled = !exclusive
        } else {
            isUserInteractionEnabled = true
        }
    }
    //=== 選択時の動作
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        dispCell()
    }
}

