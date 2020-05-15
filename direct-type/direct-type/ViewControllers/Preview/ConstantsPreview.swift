//
//  ConstantsPreview.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//選択されたTextFieldに被せているもの
class TargetAreaVW: UIView {
    override func draw(_ rect: CGRect) {
        UIColor(rgba: "#2e24").setStroke()
        UIColor(rgba: "#4f41").setFill()
        let rectangle = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        rectangle.lineWidth = 3
//        rectangle.fill()
        rectangle.stroke()
    }
}

//EditableItemKeyを付与しておき、押下イベントで個別処理をできるように拡張しておく
class IKBarButtonItem: UIBarButtonItem {
    var parentPicker: Any? = nil//IKPickerView//IKDatePicker
}
class IKDatePicker: UIDatePicker {
    var itemKey: EditableItemKey = "<undefine>"
    var parentTF: IKTextField? = nil
}
class IKPickerView: UIPickerView {
    var itemKey: EditableItemKey = "<undefine>"
    var parentTF: IKTextField? = nil
}
class IKTextField: UITextField {
    var itemKey: EditableItemKey = "<undefine>"
}

enum HPreviewItemType {
    case undefine
    //=== [H-2]個人プロフィール編集
    case fullnameH2       //===４．氏名（必須）
    case birthGenderH2    //===５．生年月日・性別（必須）
    case adderssH2        //===６．住所
    case emailH2          //===７．メールアドレス
    case mobilephoneH2    //===８．携帯電話番号
    //=== [H-3]履歴書編集
    case employmentH3           //===(3a)就業状況
    case changeCountH3          //===(3b)転職回数
    case lastJobExperimentH3    //===(3c)直近の経験職種
    case jobExperimentsH3       //===(3d)その他の経験職種
    case businessTypesH3        //===(3e)経験業種
    case schoolH3               //===(3f)最終学歴
    case skillLanguageH3        //===(3g)語学
    case qualificationsH3       //===(3h)資格
    case ownPr                  //===(3i)自己PR
    //[C-15]職務経歴書編集
    case workPeriod     //===雇用期間
    case companyName    //===企業名
    case employmentType //===雇用形態
    case employeesCount //===従業員数（数値）*これもマスタじゃないのか？ */
    case salary         //===年収
    case contents       //===職務内容本文
    
    var dispTitle: String {
        switch self {
        case .undefine:     return "<未定義>"
        //=== [H-2]個人プロフィール編集
        case .fullnameH2:     return "氏名"
        case .birthGenderH2:  return "生年月日・性別"
        case .adderssH2:      return "住所"
        case .emailH2:        return "メールアドレス"
        case .mobilephoneH2:  return "アカウント（認証済み電話番号）"
        //=== [H-3]履歴書編集
        case .employmentH3:         return "就業状況"
        case .changeCountH3:        return "転職回数"
        case .lastJobExperimentH3:  return "直近の経験職種"
        case .jobExperimentsH3:     return "その他の経験職種"
        case .businessTypesH3:      return "経験業種"
        case .schoolH3:             return "最終学歴"
        case .skillLanguageH3:      return "語学"
        case .qualificationsH3:     return "資格"
        case .ownPr:                return "自己PR"
        //[C-15]職務経歴書編集
        case .workPeriod:       return "雇用期間"
        case .companyName:      return "企業名"
        case .employmentType:   return "雇用形態"
        case .employeesCount:   return "従業員数"
        case .salary:           return "年収"
        case .contents:         return "職務内容本文"
        }
    }
}
