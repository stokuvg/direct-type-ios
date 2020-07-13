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
    @IBOutlet weak var vwMessageAreaB: UIView!
    @IBOutlet weak var lblMessageB: UILabel!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!

    @IBOutlet weak var vwPasswordArea: UIView!
    @IBOutlet weak var tfPassword: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)

        tfPassword.isSecureTextEntry = true
        tfPassword.textContentType = .password
        tfPassword.placeholder = "type用パスワード（半角英数4〜20文字）"
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
        let bufMessageB: String = "応募後に利用するパスワード"
        let bufMessage: String = [
        "転職サイトtypeを通じて応募します。",
        "利用するパスワードを入力してください。",
        "（転職サイトtypeにご登録済の方は、ご利用中のパスワードをご入力ください。）",
        "\n\(email)"].joined(separator: "")
//        let bufMessage: String = [
//        "この求人への応募は転職サイトtypeを通じて行われます。",
//        "\(email)で転職サイトtypeに登録済の方は転職サイトtypeのパスワードを、" +
//        "未登録の方はご希望のパスワードを入力ください。"].joined(separator: "")
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        lblMessageB.text(text: bufMessageB, fontType: .font_SSb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessage.text(text: bufMessage, fontType: .font_SS, textColor: UIColor(colorType: .color_black)!, alignment: .left)
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

