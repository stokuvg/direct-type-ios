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
    //余白の拡張のため
    let padding = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += ( padding.top + padding.bottom + 0 )
        intrinsicContentSize.width += ( padding.left + padding.right + 0 )
        return intrinsicContentSize
    }
}

enum HPreviewItemType: String {
    case undefine
    case spacer
    //=== [C-9]応募フォーム
    case jobCardC9      //４．応募先求人
    case profileC9      //５．プロフィール（一部必須）
    case resumeC9       //６．履歴書（一部必須）
    case careerC9       //７．職務経歴書（一部必須）
    case fixedInfoC9    //XX．固定文言
    case exQuestionC9   //１２．独自質問（必須）
    case exQAItem1C9
    case exQAItem2C9
    case exQAItem3C9
    case ownPRC9        //９．自己PR文字カウント
    case hopeAreaC9     //１０．希望勤務地（任意）
    case hopeSalaryC9   //１１．希望年収（任意）
    //=== [C-12]応募確認（[C-9]のもにに加えて表示されるものを定義）
    case notifyEntry1C12    //２．応募前の確認事項
    case passwordC12
    case notifyEntry2C12    //３．応募時に同時登録になる旨を説明
    case entryC12           //exQAItem1C9〜hopeSalaryC9をまとめたもの
    //=== [H-2]個人プロフィール編集
    case fullnameH2       //===４．氏名（必須）
    case birthH2    //===５．生年月日（必須）
    case genderH2    //===５．性別（必須）
    case adderssH2        //===６．住所
    case emailH2          //===７．メールアドレス
    case hopeAreaH2       //===希望勤務地
    case mobilephoneH2    //===８．携帯電話番号
    //=== [H-3]履歴書編集
    case employmentH3           //===(3a)就業状況
    case currentSalaryH3        //===現在の年収
    case changeCountH3          //===(3b)転職回数
    case lastJobExperimentH3    //===(3c)直近の経験職種
    case jobExperimentsH3       //===(3d)その他の経験職種
    case businessTypesH3        //===(3e)経験業種
    case schoolH3               //===(3f)最終学歴
    case skillLanguageH3        //===(3g)語学
    case qualificationsH3       //===(3h)資格
    case ownPrH3                //===(3i)自己PR
    //[C-15]職務経歴書編集
    case workPeriodC15      //===雇用期間
    case companyNameC15     //===企業名
    case employmentTypeC15  //===雇用形態
    case employeesCountC15  //===従業員数（数値）*これは直接数値入力で良い
    case salaryC15          //===年収
    case contentsC15        //===職務内容本文
    //[F系統]職歴書サクサク
    case companyNameF11     //=== [F-11] 入力（勤務先企業名）
    case businessTypesF12   //=== [F-12] 入力（在籍企業の業種）
    case employeesCountF13  //=== [F-13] 入力（社員数）
    case workPeriodF14      //=== [F-14] 入力（在籍期間）
    case employmentTypeF15  //=== [F-15] 入力（雇用形態）
    case managementsF16     //=== [F-16] 入力（マネジメント経験）
    case pcSkillF22         //=== [F-22] 職種別入力（PCスキル）
    //[A系統]初回入力
    case nicknameA6             //=== [A-5/6] 入力（ニックネーム）
    case genderA7               //=== [A-7] 入力（性別）
    case birthdayA8             //=== [A-8] 入力（生年月日）
    case hopeAreaA9             //=== [A-9] 入力（希望勤務地）
    case schoolA10              //=== [A-10] 入力（最終学歴）
    case employmentStatusA21    //=== [A-21] 入力（就業状況）
    case lastJobExperimentA11   //=== [A-11] 入力（直近経験職種）[A-12] 入力（直近の職種の経験年数）
    case currentSalaryA13              //=== [A-13] 入力（現在の年収）
    case jobExperimentsA14      //=== [A-14] 入力（追加経験職種）

    var dispTitle: String {
        switch self {
        case .undefine:     return "<未定義>"
        case .spacer:       return "<余白>"
        //=== [C-9]応募フォーム
        case .jobCardC9:      return "応募先求人"
        case .profileC9:      return "プロフィール（一部必須）"
        case .resumeC9:       return "履歴書（一部必須）"
        case .careerC9:       return "職務経歴書（一部必須）"
        case .fixedInfoC9:    return "以下はマイページに保存されません。\n応募先求人に合わせて編集してください。"
        case .exQuestionC9:   return "企業からの質問項目"
        case .exQAItem1C9:    return " - 独自質問1"
        case .exQAItem2C9:    return " - 独自質問2"
        case .exQAItem3C9:    return " - 独自質問3"
        case .ownPRC9:        return "自己PR"
        case .hopeAreaC9:     return "希望勤務地"
        case .hopeSalaryC9:   return "希望年収"
        //=== [C-12]応募確認（[C-9]のもにに加えて表示されるものを定義）
        case .notifyEntry1C12:  return "応募前の確認事項"
        case .passwordC12:      return "typeパスワード"
        case .notifyEntry2C12:  return "応募時に同時登録になる旨を説明"
        case .entryC12:         return "応募フォーム独自の追加項目"
        //=== [H-2]個人プロフィール編集
        case .fullnameH2:     return "氏名"
        case .birthH2:        return "生年月日"
        case .genderH2:       return "性別"
        case .adderssH2:      return "住所"
        case .emailH2:        return "メールアドレス"
        case .hopeAreaH2:     return "希望勤務地"
        case .mobilephoneH2:  return "アカウント（認証済み電話番号）"
        //=== [H-3]履歴書編集
        case .employmentH3:         return "就業状況"
        case .currentSalaryH3:      return "現在の年収"
        case .changeCountH3:        return "転職回数"
        case .lastJobExperimentH3:  return "直近の経験職種"
        case .jobExperimentsH3:     return "その他の経験職種"
        case .businessTypesH3:      return "経験業種"
        case .schoolH3:             return "最終学歴"
        case .skillLanguageH3:      return "語学"
        case .qualificationsH3:     return "資格"
        case .ownPrH3:                return "自己PR"
        //[C-15]職務経歴書編集
        case .workPeriodC15:        return "在籍期間"
        case .companyNameC15:       return "社名"
        case .employeesCountC15:    return "従業員数"
        case .employmentTypeC15:    return "雇用形態"
        case .salaryC15:            return "年収"
        case .contentsC15:          return "職務経歴詳細"
        //[F系統]職歴書サクサク
        case .companyNameF11:       return "勤務先企業名"
        case .businessTypesF12:     return "在籍企業の業種"
        case .employeesCountF13:    return "社員数"
        case .workPeriodF14:        return "在籍期間"
        case .employmentTypeF15:    return "雇用形態"
        case .managementsF16:       return "マネジメント経験"
        case .pcSkillF22:           return "PCスキル"
        //[A系統]初回入力
        case .nicknameA6:           return "ニックネーム"
        case .genderA7:             return "性別"
        case .birthdayA8:           return "生年月日"
        case .hopeAreaA9:           return "希望勤務地"
        case .schoolA10:            return "最終学歴"
        case .employmentStatusA21:  return "就業状況"
        case .lastJobExperimentA11: return "直近の経験職種"//& "直近の職種の経験年数"
        case .currentSalaryA13:            return "現在の年収"
        case .jobExperimentsA14:    return "追加の経験職種"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" }
}
