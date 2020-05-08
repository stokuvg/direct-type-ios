//
//  JobOfferDetailVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobOfferDetailVC: TmpBasicVC {
    
    var buttonsView:NaviButtonsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNaviButtons()
    }
    
    private func setNaviButtons() {
        let titleView = UINib(nibName: "NaviButtonsView", bundle: nil)
        .instantiate(withOwner: nil, options: nil)
            .first as! NaviButtonsView
        
        titleView.delegate = self
        self.navigationItem.titleView = titleView
        
        buttonsView = titleView
    }
    
}

extension JobOfferDetailVC: NaviButtonsViewDelegate {
    func workContentsAction() {
        buttonsView.colorChange(no:0)
    }
    
    func appImportantAction() {
        buttonsView.colorChange(no:1)
    }
    
    func employeeAction() {
        buttonsView.colorChange(no:2)
    }
    
    func informationAction() {
        buttonsView.colorChange(no:3)
    }
    
    
}
