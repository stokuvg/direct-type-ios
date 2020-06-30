//
//  EntryConfirmNotifyEntry1TBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryConfirmNotifyEntry1TBCell: UITableViewCell {
    var email: String = ""
    var password: String = ""
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var vwPasswordArea: UIView!
    @IBOutlet weak var tfPassword: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
    }
    func initCell(email: String) {
        self.email = email
    }
    func dispCell() {
        let email: String = "example@example.com" //これはProfileのものを表示させるのか
        let bufTitle: String = ["※重要※", "応募前に必ずご確認ください"].joined(separator: "\n")
        let bufMessage: String = ["この求人への応募は転職サイトtypeを通じて行われます。",
                                  "\(email)で転職サイトtypeに登録済の方はtypeのパスワードを、未登録の方はご希望のパスワードを入力ください。"].joined(separator: "")
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        lblMessage.text(text: bufMessage, fontType: .font_SS, textColor: UIColor(colorType: .color_black)!, alignment: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
