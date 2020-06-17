//
//  AccountChangeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class AccountChangeVC: TmpBasicVC {
    @IBOutlet private weak var cautionLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var nextBtn: UIButton!
    @IBAction private func nextBtnAction() {
        telephoneNumberCheck()
    }

    private var telNoString = ""
    private var displayTelNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(data:[String:Any]) {
        let telNo = data["telNo"] as! String
        displayTelNo = telNo
        telNoString = changeTelephoneNumber()
    }
}

private extension AccountChangeVC {
    func setup() {
        title = "アカウント変更"
        nextBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        let cautionText = self.makeCautionText(text:telNoString)
        
        cautionLabel.attributedText = cautionText
        inputField.font = UIFont.init(fontType: .font_L)
        inputField.textColor = UIColor.init(colorType: .color_black)
    }
    
    enum inputTelphoneErrorType {
        case none
        case empty
        case sameNumber
        
        var message: String {
            switch self {
            case .empty:
                return "電話番号が入力されていません"
            case .sameNumber:
                return "入力された番号が変わっていません"
            case .none:
                return ""
            }
        }
    }
    
    func telephoneNumberCheck() {
        var errorType: inputTelphoneErrorType = .none
        if inputField.text?.count == 0 {
            // 空入力チェック
            errorType = .empty
        } else if inputField.text == telNoString {
            // 電話番号変更チェック
            errorType = .sameNumber
        } else {
            errorType = .none
        }
        
        // エラーがある場合アラートを表示
        switch errorType {
        case .empty:
            let errorAlert = UIAlertController.init(title: "エラー", message: errorType.message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            }
            errorAlert.addAction(okAction)
            navigationController?.present(errorAlert, animated: true, completion: nil)
        case .sameNumber:
            // TODO:ニックネームを保存して設定Topへ
            navigationController?.popViewController(animated: true)
        case .none:
            // SMS認証
            let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeCompleteVC") as! AccountChangeCompleteVC
            vc.telPhone = telNoString
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func changeTelephoneNumber() -> String {
        let tel = NSMutableString()
        let cutArray = displayTelNo.components(separatedBy: "-")
        for i in 0..<cutArray.count {
            let item = cutArray[i]
            tel.append(item)
        }
        return tel as String
    }
    
    func makeCautionText(text: String) -> NSMutableAttributedString {
        let cautionText = NSMutableAttributedString.init()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_Sb) as Any
        ]
        let titleText = NSAttributedString(string: "アカウント変更には携帯電話番号の認証が必要です。\n", attributes: titleAttributes)
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_S) as Any
        ]
        let text1 = NSAttributedString(string: "\n現在の認証済み番号 ", attributes: textAttributes)
        let text2 = NSAttributedString(string: " を変更する場合は、新しい電話番号を入力してください。認証コードを送信します。", attributes: textAttributes)
        
        let telAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_sub) as Any,
            .font: UIFont(fontType: .font_S) as Any
        ]
        let textTelNo = NSAttributedString(string: text, attributes: telAttributes)
        
        cautionText.append(titleText)
        cautionText.append(text1)
        cautionText.append(textTelNo)
        cautionText.append(text2)
        
        return cautionText
    }
}
