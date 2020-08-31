//
//  EntryConfirmNotifyEntry2TBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import KeychainAccess

protocol EntryConfirmNotifyEntryDelegate {
    func changePasswordText(text: String)
    func changeAcceptStatus(isAccept: Bool)
}
class EntryConfirmNotifyEntry2TBCell: UITableViewCell {
    var delegate: EntryConfirmNotifyEntryDelegate? = nil
    var isAccept: Bool = false
    let tmpLink1: DirectTypeLinkURL = .TypeEntryPasswordForgot
    let tmpLink2: DirectTypeLinkURL = .TypeEntryPersonalInfo
    let tmpLink3: DirectTypeLinkURL = .TypeEntryMemberPolicy

    @IBOutlet weak var vwMainArea: UIView!
    
    @IBOutlet weak var vwAcceptArea: UIView!
    @IBOutlet weak var ivAccept: UIImageView!
    @IBOutlet weak var lblAccept: UILabel!
    @IBOutlet weak var textVWAccept: UITextView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBAction func actAccept(_ sender: Any) {
        isAccept = !isAccept
        ivAccept.image = isAccept ? R.image.checkOn() : R.image.checkOff()
        delegate?.changeAcceptStatus(isAccept: isAccept)
    }

    @IBOutlet weak var vwNoticeArea: UIView!
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var textVWNotice: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        selectionStyle = .none
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        vwAcceptArea.backgroundColor = UIColor(colorType: .color_base)
        vwNoticeArea.backgroundColor = UIColor(colorType: .color_base)
        textVWAccept.backgroundColor = UIColor(colorType: .color_base)
        textVWNotice.backgroundColor = UIColor(colorType: .color_base)
    }
    func initCell(_ delegate: EntryConfirmNotifyEntryDelegate) {
        self.delegate = delegate
        
        //リンク対応TextViewの属性初期化
        textVWAccept.isScrollEnabled = false
        textVWAccept.textContainerInset = UIEdgeInsets.zero
        textVWAccept.textContainer.lineFragmentPadding = 0
        textVWAccept.isSelectable = true
        textVWAccept.isEditable = false
        textVWAccept.delegate = self
        textVWAccept.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_sub)!]

        textVWNotice.isScrollEnabled = false
        textVWNotice.textContainerInset = UIEdgeInsets.zero
        textVWNotice.textContainer.lineFragmentPadding = 0
        textVWNotice.isSelectable = true
        textVWNotice.isEditable = false
        textVWNotice.delegate = self
        textVWNotice.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_sub)!]
        
        //===キーチェインから値を取得
        let keychain: Keychain = Keychain() //無視定でBundleIDが適用される
        let keyAccept: String = "accept_\(AuthManager.shared.sub)"
        if let bufAccept = try? keychain.getString(keyAccept) {
            if !bufAccept.isEmpty {
                isAccept = true
                delegate.changeAcceptStatus(isAccept: true)
            }
        }
    }
    func dispCell() {
        ivAccept.image = isAccept ? R.image.checkOn() : R.image.checkOff()
        let bufAccept: String = "転職サイトtypeの会員規約・\n個人情報に同意する"
        let bufNotice: String = [
            "※転職サイトtype未登録のメールアドレスの場合、転職サイトtypeに登録の上応募手続きを行います。",
            "転職サイトtypeに登録済みのパスワードが分からない場合はこちら。",
        ].joined(separator: "\n")
        let paraAccept = NSMutableParagraphStyle()
        paraAccept.alignment = .left
        paraAccept.lineSpacing = FontType.EC_font_Info.lineSpacing
        let attrStrAccept = NSMutableAttributedString(string: bufAccept, attributes: [
            NSAttributedString.Key.paragraphStyle : paraAccept,
            NSAttributedString.Key.font : UIFont(fontType: .EC_font_Info)!,
            NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_black)!,
            NSAttributedString.Key.underlineColor : UIColor.clear,
        ])
        attrStrAccept.addAttribute(.link,
                                      value: tmpLink2.urlText,
                                      range: NSString(string: bufAccept).range(of: tmpLink2.dispText))
        attrStrAccept.addAttribute(.link,
                                      value: tmpLink3.urlText,
                                      range: NSString(string: bufAccept).range(of: tmpLink3.dispText))
        lblAccept.attributedText = attrStrAccept
        textVWAccept.attributedText = attrStrAccept
        textVWAccept.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_sub)!]

        let paraNotice = NSMutableParagraphStyle()
        paraNotice.alignment = .left
        paraNotice.lineSpacing = FontType.EC_font_Notice.lineSpacing
        let attrStrNotice = NSMutableAttributedString(string: bufNotice, attributes: [
            NSAttributedString.Key.paragraphStyle : paraNotice,
            NSAttributedString.Key.font : UIFont(fontType: .EC_font_Notice)!,
            NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_black)!,
            NSAttributedString.Key.underlineColor : UIColor.clear,
        ])
        attrStrNotice.addAttribute(.link,
                                      value: tmpLink1.urlText,
                                      range: NSString(string: bufNotice).range(of: tmpLink1.dispText))
        lblNotice.attributedText = attrStrNotice
        textVWNotice.attributedText = attrStrNotice
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EntryConfirmNotifyEntry2TBCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
