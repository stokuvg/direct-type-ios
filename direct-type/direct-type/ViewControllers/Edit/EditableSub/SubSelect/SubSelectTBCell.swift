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
    
    @IBOutlet weak var vwCellArea: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //== セルの初期化と初期表示
    func initCell(_ delegate: SubSelectProtocol, _ item: CodeDisp, _ selected: Bool = false) {
        self.delegate = delegate
        self.item = item
        self.selectStatus = selected
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
            vwCellArea.backgroundColor = .red
            lblName.textColor = .white
        } else {
            vwCellArea.backgroundColor = .white
            lblName.textColor = .black
        }
        
    }
    //=== 選択時の動作
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        dispCell()
    }
}

