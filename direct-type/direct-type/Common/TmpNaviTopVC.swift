//
//  TmpNaviTopVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class TmpNaviTopVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor.init(colorType: .color_base)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any
            ]
            navBarAppearance.backgroundColor = UIColor.init(colorType: .color_main)
            
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        } else {

            self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_main)
            self.navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
            self.navigationController?.navigationBar.tintColor = UIColor.init(colorType: .color_white)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension TmpNaviTopVC: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
