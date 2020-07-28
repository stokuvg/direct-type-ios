//
//  EntryConfirmNotifyEntry1TBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryConfirmNotifyEntry1TBCell: UITableViewCell {
    var delegate: EntryConfirmNotifyEntryDelegate? = nil
    var email: String = ""
    var password: String = ""
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwMessageAreaB: UIView!
    @IBOutlet weak var lblMessageB: UILabel!
    @IBOutlet weak var vwPasswordArea: UIView!
    @IBOutlet weak var tfPassword: IKTextField!
    @IBOutlet weak var vwMessageAreaA: UIView!
    @IBOutlet weak var lblMessageA: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)

        tfPassword.isSecureTextEntry = true
        tfPassword.textContentType = .password
        tfPassword.placeholder = "type用パスワード（半角英数4〜20文字）"
        tfPassword.textColor = UIColor(colorType: .color_black)
        tfPassword.tintColor = UIColor(colorType: .color_black)
        tfPassword.backgroundColor = UIColor(colorType: .color_white)
    }
    func initCell(_ delegate: EntryConfirmNotifyEntryDelegate, email: String) {
        self.delegate = delegate
        self.email = email
        //===ソフトウェアキーボードに〔閉じる〕ボタン付与
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actInputCancelButton))
        toolbar.setItems([btnClose, separator1], animated: true)
        tfPassword.inputAccessoryView = toolbar
    }
    @objc func actInputCancelButton(_ sender: IKBarButtonItem) {
        self.endEditing(true)
    }
    func dispCell() {
        let bufTitle: String = ["応募前に必ずご確認ください"].joined(separator: "\n")
        let bufMessageB: String = "応募に利用するパスワード"
        let bufMessage: String = [
        "転職サイトtypeを通じて応募します。",
        "利用するパスワードを入力してください。",
        "（転職サイトtypeにご登録済の方は、ご利用中のパスワードを入力してください。）",
        ].joined(separator: "")
        let bufMessageA: String = "メールアドレス：\(email)"
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        lblMessage.text(text: bufMessage, fontType: .EC_font_Info, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessageB.text(text: bufMessageB, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessageA.text(text: bufMessageA, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//=== 文字入力に伴うTextField関連の通知
extension EntryConfirmNotifyEntry1TBCell {
    @IBAction func editingChanged(_ sender: UITextField) {
        delegate?.changePasswordText(text: sender.text ?? "")        
    }
}

