//
//  SubSelectEnableVW.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol SubSelectEnableDelegate {
    func actSelectChange(isEnable: Bool)
}
class SubSelectEnableVW: UIView {
    var delegate: SubSelectEnableDelegate? = nil
    var title: String = ""
    var selectStatus: Bool = false
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var stackVW: UIStackView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    fileprivate func commonInit() {
        guard let view = UINib(nibName: "SubSelectEnableVW", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        stackVW.axis = .vertical
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_main)
    }
    //== セルの初期化と初期表示
    init(_ delegate: SubSelectEnableDelegate, _ title: String, _ selected: Bool = false) {
        self.init()
        self.delegate = delegate
        self.title = title
        self.selectStatus = selected
    }
    func dispData() {
        self.backgroundColor = .yellow
        if selectStatus {
            vwMainArea.backgroundColor = UIColor(colorType: .color_sub)
            lblTitle.textColor = .white
        } else {
            vwMainArea.backgroundColor = .white
            lblTitle.textColor = .black
        }
    }
}
