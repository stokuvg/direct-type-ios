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
    var isValidErrorExist: Bool = false
    var isSaveChk: Bool = Constants.TypeEntrySaveCheckDefault
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwMessageAreaB: UIView!
    @IBOutlet weak var lblMessageB: UILabel!
    @IBOutlet weak var vwValidateErrorArea: UIView!
    @IBOutlet weak var lblValidateError: UILabel!
    @IBOutlet weak var vwPasswordArea: UIView!
    @IBOutlet weak var tfPassword: IKTextField!
    @IBOutlet weak var vwMessageAreaA: UIView!
    @IBOutlet weak var lblMessageA: UILabel!
    //保存するか尋ねる
    @IBOutlet weak var vwSaveChkArea: UIView!
    @IBOutlet weak var lblSaveChk: UILabel!
    @IBOutlet weak var btnSaveChk: UIButton!
    @IBAction func actSaveChk(_ sender: Any) {
        isSaveChk = !isSaveChk
        dispSaveChk()
        delegate?.changeSaveChkBox(isSaveChk: isSaveChk)
    }
    private func dispSaveChk() {
        let bufSaveChk: String = isSaveChk ? "■ 保存する" : "□ 保存する"
        lblSaveChk.text(text: bufSaveChk, fontType: .font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .right)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        selectionStyle = .none
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)

        tfPassword.isSecureTextEntry = false
        tfPassword.textContentType = .password
        tfPassword.keyboardType = .asciiCapable
        tfPassword.attributedPlaceholder = NSAttributedString(string: "type用パスワード（半角英数4〜20文字）", attributes: [NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_light_gray)!])
        tfPassword.textColor = UIColor(colorType: .color_black)
        tfPassword.tintColor = UIColor(colorType: .color_black)
        tfPassword.backgroundColor = UIColor(colorType: .color_white)

        btnSaveChk.setTitle("", for: .normal)
    }
    func initCell(_ delegate: EntryConfirmNotifyEntryDelegate, email: String, isValidError: Bool) {
        self.delegate = delegate
        self.email = email
        self.isValidErrorExist = isValidError
        //===ソフトウェアキーボードに〔閉じる〕ボタン付与
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actInputCancelButton))
        toolbar.setItems([btnClose, separator1], animated: true)
        tfPassword.inputAccessoryView = toolbar
        //===キーチェインから値を取得
        if let bufPassword = TudKeyChain.password(email: email).value() {
            tfPassword.text = bufPassword
            delegate.changePasswordText(text: bufPassword)
        }
    }
    @objc func actInputCancelButton(_ sender: IKBarButtonItem) {
        self.endEditing(true)
    }
    func changeErrorStatus(isValidErrorExist: Bool) {
        self.isValidErrorExist = isValidErrorExist
    }
    func dispCell() {
        let bufTitle: String = ["応募前に必ずご確認ください"].joined(separator: "\n")
        let bufMessageB: String = "応募に利用するパスワード"
        let bufMessage: String = [
        "転職サイトtypeを通じて応募します。",
        "パスワードを設定してください。",
        "（転職サイトtypeにご登録済の方は、ご利用中のパスワードを入力してください。）",
        ].joined(separator: "")
        let bufMessageA: String = "メールアドレス：\(email)"
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        lblMessage.text(text: bufMessage, fontType: .EC_font_Info, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessageB.text(text: bufMessageB, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessageA.text(text: bufMessageA, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        //===エラーが存在した場合
        let validMessage: String = "半角英数字で4文字以上、20文字以内です"
        if isValidErrorExist {
            tfPassword.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            lblValidateError.text(text: validMessage, fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
        } else {
            tfPassword.backgroundColor = UIColor(colorType: .color_white)
            lblValidateError.text(text: validMessage, fontType: .font_SS, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        }
        dispSaveChk() //保存チェック
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

