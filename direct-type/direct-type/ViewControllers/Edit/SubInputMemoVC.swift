//
//  SubInputMemoVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SubInputMemoVC: BaseVC {
    var editableItem: EditableItemH!
    var delegate: SubSelectFeedbackDelegate? = nil

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        actPopupCancel()
    }

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var textVW: UITextView!
    
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        let bufText: String = textVW.text ?? ""
        actPopupSelect(text: bufText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //====デザイン適用
        view.backgroundColor = UIColor(colorType: .color_base)!
        vwHead.backgroundColor = UIColor(colorType: .color_main)!
        vwMain.backgroundColor = UIColor(colorType: .color_base)!
        vwFoot.backgroundColor = UIColor(colorType: .color_base)!
        textVW.textColor = UIColor(colorType: .color_black)
        btnCommit.setTitle(text: "選択", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        //===ソフトウェアキーボードに〔閉じる〕ボタン付与
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actInputCancelButton))
        toolbar.setItems([btnClose, separator1], animated: true)
        textVW.inputAccessoryView = toolbar
    }
    @objc func actInputCancelButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(true)
    }

    func initData(_ delegate: SubSelectFeedbackDelegate, editableItem: EditableItemH) {
        self.delegate = delegate
        self.editableItem = editableItem
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName)"
        lblTitle.text(text: bufTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        textVW.text = editableItem.curVal
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
}

//=== テキスト入力したものの確定処理 ===
extension SubInputMemoVC {
    func actPopupSelect(text: String) {
        self.delegate?.changedSelect(editItem: self.editableItem, codes: text)
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}
