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
        let bufValue: String = dispCellValue(_item)
        
        //===表示させる
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


extension HPreviewTBCell {
    func dispCellValue(_ _item: MdlItemH) -> String {
        switch _item.type {
        case .undefine:
            return "<未定義>"
        case .fullnameH2:
            let bufFullname: String = "\(_item.childItems[0].valDisp) \(_item.childItems[1].valDisp)"
            let bufFullnameKana: String = "\(_item.childItems[2].valDisp) \(_item.childItems[3].valDisp)"
            return "\(bufFullname)（\(bufFullnameKana)）"
        case .birthGenderH2:
            let tmpBirthday: String = _item.childItems[0].curVal
            let date = DateHelper.convStr2Date(tmpBirthday)
            let bufBirthday: String = date.dispYmdJP()
            let bufAge: String = "\(date.age)歳"
            let tmpGender: String = _item.childItems[1].curVal
            let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
            return "\(bufBirthday)（\(bufAge)） / \(bufGender)"
        case .adderssH2:
            let tmp0: String = _item.childItems[0].valDisp
            let buf0: String = "\(String.substr(tmp0, 1, 3))-\(String.substr(tmp0, 4, 4))"
            let tmp1: String = _item.childItems[1].curVal
            print(tmp1)
            let buf1: String = SelectItemsManager.getCodeDisp(.place, code: tmp1)?.disp ?? "---"
            let buf2: String = _item.childItems[2].valDisp
            let buf3: String = _item.childItems[3].valDisp
            let bufAddress: String = "\(buf1)\(buf2)\(buf3)"
            return "〒\(buf0)\n\(bufAddress)"

        case .employmentH3:
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employment, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .changeCountH3:
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.changeCount, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .lastJobExperimentH3:
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDispSyou(.jobType, code: tmp0)?.disp ?? ""
            let tmp1: String = _item.childItems[1].curVal
            let buf1: String = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: tmp1)?.disp ?? ""
            let bufExperiment = "\(buf0) \(buf1)"
            return bufExperiment
        case .jobExperimentsH3:
            let val: String = "3:2_5:3_55:4_9:5_11:6_13:7_11"
            var disp: [String] = []
            for job in val.split(separator: "_") {
                let buf = String(job).split(separator: ":")
                guard buf.count == 2 else { continue }
                let tmp0 = String(buf[0])
                let tmp1 = String(buf[1])
                let buf0: String = SelectItemsManager.getCodeDispSyou(.jobType, code: tmp0)?.disp ?? ""
                let buf1: String = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: tmp1)?.disp ?? ""
                let bufExperiment: String = "\(buf0) \(buf1)"
                disp.append(bufExperiment)
            }
            return disp.joined(separator: "\n")
        case .businessTypesH3:
            var disp: [String] = []
            for businessType in _item.childItems {
                let tmp0: String = businessType.curVal
                let buf0: String = SelectItemsManager.getCodeDispSyou(.businessType, code: tmp0)?.disp ?? ""
                disp.append(buf0)
            }
            return disp.joined(separator: "\n")
        case .schoolH3:
            let buf0: String = _item.childItems[0].curVal
            let buf1: String = _item.childItems[1].curVal
            let buf2: String = _item.childItems[2].curVal
            let buf3: String = _item.childItems[3].curVal
            return "\(buf0)\n\(buf1)\(buf2)\n\(buf3)"
        case .skillLanguageH3:
            let tmp0: String = _item.childItems[0].curVal
            let tmp1: String = _item.childItems[1].curVal
            let buf0: String = tmp0.isEmpty ? "--" : tmp0
            let buf1: String = tmp1.isEmpty ? "--" : tmp1
            let bufToeicToefl: String = "TOEIC：\(buf0) / TOEFL：\(buf1)"
            let tmp2: String = _item.childItems[2].curVal
            let buf2: String = SelectItemsManager.getCodeDisp(.skillEnglish, code: tmp2)?.disp ?? ""
            let buf3: String = _item.childItems[3].curVal
            var disp: [String] = []
            disp.append(bufToeicToefl)
            if !buf2.isEmpty { disp.append(buf2) }
            if !buf3.isEmpty { disp.append(buf3) }
            return disp.joined(separator: "\n")
        case .qualificationsH3:
            var disp: [String] = []
            for businessType in _item.childItems {
                let tmp0: String = businessType.curVal
                let buf0: String = SelectItemsManager.getCodeDisp(.qualification, code: tmp0)?.disp ?? ""
                disp.append(buf0)
            }
            return disp.joined(separator: "\n")

        default:
            return _item.childItems[0].curVal
        }
    }
}
