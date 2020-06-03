//
//  AccountChangeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class AccountChangeVC: TmpBasicVC {
    
    @IBOutlet weak var cautionLabel:UILabel!
    
    @IBOutlet weak var inputField:UITextField!
    
    @IBOutlet weak var nextBtn:UIButton!
    @IBAction func nextBtnAction() {
        
    }

    var telNoString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "アカウント変更"
        
        nextBtn.setTitle(text: "次へ", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        let cautionText = self.makeCautionText(text:telNoString)
        
        self.cautionLabel.attributedText = cautionText
        
        inputField.font = UIFont.init(fontType: .font_L)
        inputField.textColor = UIColor.init(colorType: .color_black)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setup(data:[String:Any]) {
        let telNo = data["telNo"] as! String
        
        telNoString = telNo
    }
    
    private func makeCautionText(text:String) -> NSMutableAttributedString {
        let cautionText = NSMutableAttributedString.init()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_black) as Any,
            .font: UIFont.init(fontType: .font_Sb) as Any
        ]
        let titleText = NSAttributedString(string: "アカウント変更には携帯電話番号の認証が必要です。\n", attributes: titleAttributes)
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_black) as Any,
            .font: UIFont.init(fontType: .font_S) as Any
        ]
        let text1 = NSAttributedString(string: "\n現在の認証済み番号 ", attributes: textAttributes)
        let text2 = NSAttributedString(string: " を変更する場合は、新しい電話番号を入力してください。認証コードを送信します。", attributes: textAttributes)
        
        let telAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_sub) as Any,
            .font: UIFont.init(fontType: .font_S) as Any
        ]
        let textTelNo = NSAttributedString(string: text, attributes: telAttributes)
        
        cautionText.append(titleText)
        cautionText.append(text1)
        cautionText.append(textTelNo)
        cautionText.append(text2)
        
        return cautionText
    }

}
