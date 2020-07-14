//
//  AccountChangeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SwaggerClient
import SVProgressHUD
import AWSMobileClient

final class AccountChangeVC: TmpBasicVC {
    @IBOutlet private weak var cautionLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var nextBtn: UIButton!
    @IBAction private func nextBtnAction() {
        tryAccountChange()
    }

    private var profile: MdlProfile?
    private var existingPhoneNumber = ""
    private let phoneNumberMaxLength: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(with profile: MdlProfile) {
        self.profile = profile
        existingPhoneNumber = extractNumbers(from: profile.mobilePhoneNo)
    }
}

private extension AccountChangeVC {
    func setup() {
        title = "アカウント変更"
        cautionLabel.attributedText = makeCautionText(text: existingPhoneNumber)
        inputField.font = UIFont(fontType: .font_L)
        inputField.textColor = UIColor(colorType: .color_black)
        inputField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
        nextBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        changeButtonState()
    }
    
    var isValidPhoneNumber: Bool {
        guard let inputText = inputField.text, !inputText.isEmpty else { return false }
        return true
    }
    
    func tryAccountChange() {
        guard let inputText = inputField.text, inputText != existingPhoneNumber else {
            // 既存の電話番号と同じだった場合はニックネームを保存して設定Topへ
            // TODO: ニックネームの保存処理を追加
            navigationController?.popViewController(animated: true)
            return
        }
        
        let param = AccountMigrateRequest(phoneNumber: inputText.addCountryCode(type: .japan))
        
        SVProgressHUD.show()
        ApiManager.accountMigrate(param)
        .done { result in
            self.transitionToConfirmation()
        }
        .catch { (error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                print(#line, #function, error.localizedDescription)
                self.showConfirm(title: "電話番号変更エラー", message: "別の電話番号で再度お試しください。", onlyOK: true)
            }
        }
        .finally {
            SVProgressHUD.dismiss()
        }
    }
    
    func transitionToConfirmation() {
        guard let inputText = inputField.text else { return }
        let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeCompleteVC") as! AccountChangeConfirmVC
        vc.configure(with: inputText)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func extractNumbers(from text: String) -> String {
        let tel = NSMutableString()
        let cutArray = text.components(separatedBy: "-")
        for i in 0..<cutArray.count {
            let item = cutArray[i]
            tel.append(item)
        }
        return tel as String
    }
    
    var isValidInputText: Bool {
        guard let inputText = inputField.text, inputField.markedTextRange == nil,
            inputText.count == phoneNumberMaxLength else { return false }
        return true
    }
    @objc
    func changeButtonState() {
        guard let inputText = inputField.text else { return }
        inputField.text = inputText.prefix(phoneNumberMaxLength).description
        nextBtn.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextBtn.isEnabled = isValidInputText
    }
    
    func makeCautionText(text: String) -> NSMutableAttributedString {
        let cautionText = NSMutableAttributedString()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_Sb) as Any
        ]
        let titleText = NSAttributedString(string: "アカウント変更には携帯電話番号の認証が必要です。\n", attributes: titleAttributes)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_S) as Any,
            .paragraphStyle: paragraphStyle
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
