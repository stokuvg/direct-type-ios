//
//  NaviButtonsView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/07.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol NaviButtonsViewDelegate {
    func workContentsAction()
    func appImportantAction()
    func employeeAction()
    func informationAction()
}

class NaviButtonsView: UIView {
    /*
     The work contents.
     Application important matter.
     Treatment and employee benefits.
     Industrial information.
     */
    
    @IBOutlet weak var workContentsBtn:UIButton!
    @IBAction func workContentsBtnAction() {
        self.delegate.workContentsAction()
    }
    @IBOutlet weak var appImportantBtn:UIButton!
    @IBAction func appImportantBtnAction() {
        self.delegate.appImportantAction()
    }
    @IBOutlet weak var employeeBtn:UIButton!
    @IBAction func employeeBtnAction() {
        self.delegate.employeeAction()
    }
    @IBOutlet weak var infomationBtn:UIButton!
    @IBAction func infomationBtnAction() {
        self.delegate.informationAction()
    }
    
    var delegate:NaviButtonsViewDelegate!
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.init(colorType: .color_sub)
        
        workContentsBtn.setNoRadiusTitle(text: "仕事内容", fontType: .font_SSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        workContentsBtn.backgroundColor = UIColor.init(colorType: .color_black)
        
        appImportantBtn.setNoRadiusTitle(text: "応募資格", fontType: .font_SSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        appImportantBtn.backgroundColor = UIColor.init(colorType: .color_black)
        
        employeeBtn.setNoRadiusTitle(text: "待遇", fontType: .font_SSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        employeeBtn.backgroundColor = UIColor.init(colorType: .color_black)
        
        infomationBtn.setNoRadiusTitle(text: "企業情報", fontType: .font_SSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        infomationBtn.backgroundColor = UIColor.init(colorType: .color_black)
    }
    
    func colorChange(no:Int) {
        switch no {
            case 0:
                workContentsBtn.backgroundColor = UIColor.init(colorType: .color_sub)
                appImportantBtn.backgroundColor = UIColor.init(colorType: .color_black)
                employeeBtn.backgroundColor = UIColor.init(colorType: .color_black)
                infomationBtn.backgroundColor = UIColor.init(colorType: .color_black)
            case 1:
                workContentsBtn.backgroundColor = UIColor.init(colorType: .color_black)
                appImportantBtn.backgroundColor = UIColor.init(colorType: .color_sub)
                employeeBtn.backgroundColor = UIColor.init(colorType: .color_black)
                infomationBtn.backgroundColor = UIColor.init(colorType: .color_black)
            case 2:
                workContentsBtn.backgroundColor = UIColor.init(colorType: .color_black)
                appImportantBtn.backgroundColor = UIColor.init(colorType: .color_black)
                employeeBtn.backgroundColor = UIColor.init(colorType: .color_sub)
                infomationBtn.backgroundColor = UIColor.init(colorType: .color_black)
            case 3:
                workContentsBtn.backgroundColor = UIColor.init(colorType: .color_black)
                appImportantBtn.backgroundColor = UIColor.init(colorType: .color_black)
                employeeBtn.backgroundColor = UIColor.init(colorType: .color_black)
                infomationBtn.backgroundColor = UIColor.init(colorType: .color_sub)
            default:
                workContentsBtn.backgroundColor = UIColor.init(colorType: .color_black)
                appImportantBtn.backgroundColor = UIColor.init(colorType: .color_black)
                employeeBtn.backgroundColor = UIColor.init(colorType: .color_black)
                infomationBtn.backgroundColor = UIColor.init(colorType: .color_black)
        }
    }

}
