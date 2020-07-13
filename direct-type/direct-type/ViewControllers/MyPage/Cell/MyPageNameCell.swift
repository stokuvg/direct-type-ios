//
//  MyPageNameCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol MyPageNameCellDelegate {
    func actEditNickname()
}
class MyPageNameCell: BaseTableViewCell {
    var delegate: MyPageNameCellDelegate? = nil
    var nickname: String = "ゲストさん"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var editImage:UIImageView!
    /*
    @IBOutlet weak var editBtn:UIButton!
    @IBAction func editBtnAction() {
        delegate?.actEditNickname()
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        editBtn.isHidden = false//変更不可にしておくよ
        dispCell()
    }
  //== セルの初期化と初期表示
    func initCell(_ delegate: MyPageNameCellDelegate, _ nickname: String) {
        self.delegate = delegate
        self.nickname = nickname
    }
   func dispCell() {
       nameLabel.text(text: nickname, fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .right)
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
