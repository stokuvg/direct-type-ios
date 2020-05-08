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
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor.init(colorType: .color_base)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func title(name:String) {
        self.navigationController?.navigationBar.topItem?.title = name
    }

}

extension TmpNaviTopVC: UINavigationBarDelegate {
    
    /*
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    */
}
