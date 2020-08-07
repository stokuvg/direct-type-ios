//
//  SpacerTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//ただの余白をつけるためのセル

class SpacerTBCell: UITableViewCell {
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var lcMainAreaHeight: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        lcMainAreaHeight.constant = 20
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
