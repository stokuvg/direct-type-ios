//
//  HPreviewTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MdlItemH {
    var type: HPreviewItemType = .undefine
    var value: String = ""
    var notice: String = ""
    var readonly: Bool = false
    var childItems: [EditableItemH] = []
    
    convenience init(_ type: HPreviewItemType, _ value: String, _ notice: String = "", readonly: Bool = false, childItems: [EditableItemH]) {
        self.init()
        self.type = type
        self.value = value
        self.notice = notice
        self.readonly = readonly
        self.childItems = childItems
    }
        
    var debugDisp: String {
        return "[\(type.dispTitle)] [\(value)]（\(childItems.count)件のサブ項目） [\(readonly ? "変更不可" : "")] [\(notice)]"
    }
}

class HPreviewTBCell: UITableViewCell {
    var item: MdlItemH? = nil
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblNotice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(_ item: MdlItemH) {
        self.item = item
        if item.readonly {
            self.isUserInteractionEnabled = false
            self.accessoryType = .none
        } else {
            self.isUserInteractionEnabled = true
            self.accessoryType = .disclosureIndicator
        }
    }
    
    func dispCell() {
        guard let _item = item else { return }
        //===表示用文字列の生成
        let bufTitle: String = _item.type.dispTitle
        //let bufValue: String = _item.value
        let bufNotice: String = _item.notice
        var bufValue: String {
            switch _item.type {
            case .undefine:
                return "<未定義>"
            case .fullname:
                let bufFullname: String = "\(_item.childItems[0].valDisp) \(_item.childItems[1].valDisp)"
                let bufFullnameKana: String = "\(_item.childItems[2].valDisp) \(_item.childItems[3].valDisp)"
                return "\(bufFullname)（\(bufFullnameKana)）"
            case .birthGender:
                let bufBirthdayY: String = _item.childItems[0].valDisp
                let bufBirthdayM: String = _item.childItems[1].valDisp
                let bufBirthdayD: String = _item.childItems[2].valDisp
                let bufBirthday: String = "\(bufBirthdayY)年\(bufBirthdayM)月\(bufBirthdayD)日"
                let tmpAge: Int = 23
                let bufAge: String = "\(tmpAge)歳"
                let tmpGender: String = _item.childItems[3].valDisp
                print("\t[tmpGender: \(tmpGender)]")
                let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
                print("\t[bufGender: \(bufGender)]")
                return "\(bufBirthday)（\(bufAge)） / \(bufGender)"
            case .adderss:
                let tmpZipCode: String = _item.childItems[0].valDisp
                let bufZipCode: String = "\(String.substr(tmpZipCode, 1, 3))-\(String.substr(tmpZipCode, 4, 4))"
                let tmpPrefecture: String = _item.childItems[1].valDisp
                let bufPrefecture: String = SelectItemsManager.getCodeDisp(.place, code: tmpPrefecture)?.disp ?? ""
                let bufAddress: String = "\(bufPrefecture)\(_item.childItems[2].valDisp)\(_item.childItems[3].valDisp)"
                return "〒\(bufZipCode)\n\(bufAddress)"
            case .email:
                let bufMailAddress: String = _item.childItems[0].valDisp
                return bufMailAddress
            case .mobilephone:
                let bufMobilePhoneNo: String = _item.childItems[0].valDisp
                return bufMobilePhoneNo
            default:
                return ""
            }
        }
        
        //===表示mさせる
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        lblValue.text(text: bufValue, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        lblNotice.text(text: bufNotice, fontType: .font_SS, textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        if _item.notice == "" {
            lblNotice.isHidden = true
        } else {
            lblNotice.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
