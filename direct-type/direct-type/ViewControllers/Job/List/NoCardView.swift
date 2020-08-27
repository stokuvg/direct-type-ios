//
//  NoCardView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/07.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol NoCardViewDelegate {
    func registEditAction()
}

class NoCardView: UIView {
    
    @IBOutlet weak var sumazawaImageBackView:UIView!
    @IBOutlet weak var sumazawaImage:UIImageView!
    @IBOutlet weak var noJobLabel:UILabel!
    @IBOutlet weak var jobInfomationLabel:UILabel!
    @IBOutlet weak var registEditBtnBackView:UIView!
    @IBOutlet weak var registEditBtn:UIButton!
    @IBAction func registEditBtnAction() {
        self.delegate.registEditAction()
    }
    
    var delegate:NoCardViewDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        sumazawaImageBackView.layer.cornerRadius = 15
        sumazawaImageBackView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        registEditBtnBackView.layer.cornerRadius = 15
        registEditBtnBackView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        noJobLabel.text(text: "現在 ゲストさん におすすめできる求人はありません", fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
//        jobInfomationLabel.text(text: " ゲストさん の登録情報を更新することで、おすすめできる求人が増える可能性があります", fontType: .font_SS, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        /*申し訳ありません。
        今、おすすめできる求人はありません。
        マイページから希望勤務地を増やしてもらえると
        新たにあなたにぴったりの求人が探せるかもしれません。
        マイページを更新後、下のボタンを押して更新してください*/
//        jobInfomationLabel.text(text: "申し訳ありません。これ以上、おすすめできる求人がありませんので、明日以降でお試しください", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        jobInfomationLabel.text(text: "ごめんなさい。マイページから希望勤務地を増やしてみてね！あなたにぴったりの求人が探せるかもしれません。マイページ更新後、ボタンを押してみてください！", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        
//        registEditBtn.setTitle(text: "登録情報を編集する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        registEditBtn.setTitle(text: "おすすめ求人を更新する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        registEditBtn.backgroundColor = UIColor.init(colorType: .color_button)
        registEditBtn.isHidden = false
    }
    
    func setup(profileData:MdlProfile) {
        
        if profileData.nickname.count > 0 {
            
            let nickName = profileData.nickname
            noJobLabel.text(text: "現在 " + nickName + " さんにおすすめできる求人はありません", fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
//            jobInfomationLabel.text(text: nickName + " さんの登録情報を更新することで、おすすめできる求人が増える可能性があります", fontType: .font_SS, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        }
    }

}
