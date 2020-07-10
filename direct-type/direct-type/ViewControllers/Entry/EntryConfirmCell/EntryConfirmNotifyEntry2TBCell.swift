//
//  EntryConfirmNotifyEntry2TBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol EntryConfirmNotifyEntryDelegate {
    func changePasswordText(text: String)
    func changeAcceptStatus(isAccept: Bool)
    func actLinkText(type: EntryConfirmLinkTextType)
}
enum EntryConfirmLinkTextType {
    case passwordForgot
    case personalInfo
    case memberPolicy
}
class EntryConfirmNotifyEntry2TBCell: UITableViewCell {
    var delegate: EntryConfirmNotifyEntryDelegate? = nil
    var isAccept: Bool = false

    @IBOutlet weak var vwMainArea: UIView!

    @IBOutlet weak var vwAcceptArea: UIView!
    @IBOutlet weak var lblAccept: UILabel!
    @IBOutlet weak var ivAccept: UIImageView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBAction func actAccept(_ sender: Any) {
        isAccept = !isAccept
        ivAccept.image = isAccept ? R.image.checkOn() : R.image.checkOff()
        delegate?.changeAcceptStatus(isAccept: isAccept)
    }

    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!

    @IBOutlet weak var vwLinkText1Area: UIView!
    @IBOutlet weak var lblLinkText1: UILabel!
    @IBOutlet weak var btnLinkText1: UIButton!
    @IBAction func actLinkText1(_ sender: Any) {
        delegate?.actLinkText(type: .passwordForgot)
    }
    @IBOutlet weak var vwLinkText2Area: UIView!
    @IBOutlet weak var lblLinkText2: UILabel!
    @IBOutlet weak var btnLinkText2: UIButton!
    @IBAction func actLinkText2(_ sender: Any) {
        delegate?.actLinkText(type: .personalInfo)
    }
    @IBOutlet weak var vwLinkText3Area: UIView!
    @IBOutlet weak var lblLinkText3: UILabel!
    @IBOutlet weak var btnLinkText3: UIButton!
    @IBAction func actLinkText3(_ sender: Any) {
        delegate?.actLinkText(type: .memberPolicy)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
    }
    func initCell(_ delegate: EntryConfirmNotifyEntryDelegate) {
        self.delegate = delegate
    }
    func dispCell() {
        ivAccept.image = isAccept ? R.image.checkOn() : R.image.checkOff()
        let bufAccept: String = "転職typeの会員規約・個人情報方針に同意する"
        let bufMessage: String = "※type未登録のメールアドレスの場合、typeに登録の上応募手続きを行います。"
        let bufLink1: String = "転職サイトtypeに登録済みのパスワードがわからない場合"
        let bufLink2: String = "転職サイトtypeの個人情報の取り扱いについて"
        let bufLink3: String = "転職サイトtypeの会員規約"
        lblAccept.text(text: bufAccept, fontType: .font_SS, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessage.text(text: bufMessage, fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
        lblLinkText1.text(text: bufLink1, fontType: .font_SS, textColor: UIColor(colorType: .color_button)!, alignment: .left)
        lblLinkText2.text(text: bufLink2, fontType: .font_SS, textColor: UIColor(colorType: .color_button)!, alignment: .left)
        lblLinkText3.text(text: bufLink3, fontType: .font_SS, textColor: UIColor(colorType: .color_button)!, alignment: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
