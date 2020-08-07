//
//  DlgStackButton.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/10.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

//=== ダイアログの動作を設定するModel
typealias DlgItemCompletion = () -> Void
enum DlgActionType: CaseIterable {
    //=== 共通ダイアログ
    case dlgCmnBtnOK
    case dlgCmnBtnNG
    case dlgCmnBtnCancel

    var disp: String {
        switch self {
        case .dlgCmnBtnOK:      return "はい"
        case .dlgCmnBtnNG:      return "いいえ"
        case .dlgCmnBtnCancel:  return "キャンセル"
        }
    }
}
struct DlgActionItem {
    var action: DlgActionType
    var completion: DlgItemCompletion?
    
    var disp: String {
        return "\(action.disp)"
    }
}
struct DlgDetail {
    enum AxisType {
        case horizontal //よこ
        case vertical   //たて
    }
    var title: String = ""
    var message: String = ""
    var buttons: [DlgActionItem] = []
    var axisType: AxisType = .horizontal
}

protocol DlgStackButtonProtocol {
    func actDlgButton(_ sender: DlgActionItem)
}

class DlgStackButton: UIButton {
    var item: DlgActionItem!
    var delegate: DlgStackButtonProtocol!

    init(_ item: DlgActionItem, _ target: DlgStackButtonProtocol) {
        super.init(frame: CGRect.zero)
        self.delegate = target
        self.item = item
        self.setTitle(item.action.disp, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
        self.addTarget(self, action: #selector(actDlgButton(_:)), for: UIControl.Event.touchUpInside)
        //===見た目のカスタマイズ
        self.backgroundColor = UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1.0)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 29)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func actDlgButton(_ sender: DlgStackButton) {
        self.delegate.actDlgButton(self.item)
    }
    var debugDisp: String {
        return "〔\(item.disp)] [\(frame.debugDescription)〕ボタン"
    }
    
}
