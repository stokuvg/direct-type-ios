//
//  EntryConfirmItem.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryConfirmItem: UIView {
    var title: String = ""
    var message: String = ""

    @IBOutlet weak var vwMainArea: UIView!

    @IBOutlet weak var stackVW: UIStackView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    fileprivate func commonInit() {
        guard let view = UINib(nibName: "EntryConfirmItem", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        stackVW.axis = .vertical
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
    }
    init(_ title: String, _ message: String) {
        self.init()
        self.title = title
        self.message = message
    }
    func dispCell() {
        lblTitle.text(text: title, fontType: .font_SSb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblMessage.text(text: message, fontType: .font_SS, textColor: UIColor(colorType: .color_black)!, alignment: .left)
    }
}



