//
//  JobDetailFoldingPhoneNumberCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class HomePageUrlView: UIView {
    
    @IBOutlet weak var urlTextView:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.urlTextView.textColor = UIColor.init(colorType: .color_black)
        self.urlTextView.font = UIFont.init(fontType: .C_font_S)
        self.urlTextView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(colorType: .color_sub) as Any
        ]
        self.urlTextView.dataDetectorTypes = .link
        self.urlTextView.isEditable = false
        self.urlTextView.isSelectable = true
        self.urlTextView.delegate = self
        
        self.urlTextView.isUserInteractionEnabled = true
    }
    
    func setup(urlString: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = FontType.C_font_S.lineSpacing
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_black) as Any,
            NSAttributedString.Key.paragraphStyle : style,
//            NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_sub)
        ]
        let attributedString = NSMutableAttributedString(string: urlString)
        
        self.urlTextView.attributedText = NSAttributedString(string: attributedString.string, attributes: attributes)
    }
}

class JobDetailFoldingPhoneNumberCell: BaseTableViewCell {
    
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var homePageView:HomePageUrlView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.textColor = UIColor.init(colorType: .color_black)
        self.textView.font = UIFont.init(fontType: .C_font_S)
        self.textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(colorType: .color_black) as Any
        ]
        self.textView.dataDetectorTypes = .link
        self.textView.isSelectable = true
        self.textView.delegate = self
        
        self.textView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: JobCardDetailContactInfo){
//    func setup(data: [String: Any]) {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = FontType.C_font_S.lineSpacing
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_black) as Any,
            NSAttributedString.Key.paragraphStyle : style,
//            NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_sub)
        ]
        
        let urlString = data.companyUrl
        let zipCodeString = data.contactZipcode
        let addressString = data.contactAddress
        let telString = data.contactPhone
        let personString = data.contactPerson
        let emailString = data.contactMail
        
        let text = self.makeAdoptionText(zipCode: zipCodeString, address: addressString, tel: telString, person: personString, email: emailString)

        let attributedString = NSMutableAttributedString(string: text)
        
        self.textView.attributedText = NSAttributedString(string: attributedString.string, attributes: attributes)

        homePageView.setup(urlString: urlString)
    }
    
    private func makeAdoptionText(zipCode:String,address:String,tel:String,person:String,email:String) -> String {
        let text = NSMutableString()
        
        // 郵便番号         必須
        // 住所            必須
        // 担当者          任意
        // 電話番号         任意
        // メールアドレス     任意
        // URL             任意
        text.append("〒 ")
        text.append(zipCode)
        text.append("\n")
        
        text.append(address)
        text.append("\n")
        
        if tel.count > 0 {
            text.append("TEL / ")
            text.append(tel)
            text.append("\n")
        }
        
        if email.count > 0 {
            text.append("E-mail / ")
            text.append(email)
            text.append("\n")
        }
        
        if person.count > 0 {
            text.append(person)
        }
        
        return text as String
    }
    
}

extension JobDetailFoldingPhoneNumberCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        Log.selectLog(logLevel: .debug, "JobDetailFoldingPhoneNumberCell shouldInteractWith start")
        
        /*
        if textView == urlTextView {
//        Log.selectLog(logLevel: .debug, "URL:\(URL)")
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            return true
        }
        */
        
        return false
    }
}

extension HomePageUrlView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        Log.selectLog(logLevel: .debug, "JobDetailFoldingPhoneNumberCell shouldInteractWith start")
        
//        Log.selectLog(logLevel: .debug, "URL:\(URL)")
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return true
    }
}
