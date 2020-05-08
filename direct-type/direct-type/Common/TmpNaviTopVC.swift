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
        
//        self.navigationController?.navigationBar.delegate = self
        
        self.view.backgroundColor = UIColor.init(colorType: .color_base)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Log.selectLog(logLevel: .debug, "TmpNaviTopVC viewWillAppear start")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Log.selectLog(logLevel: .debug, "TmpNaviTopVC viewDidAppear start")
    }
    
    func title(name:String) {
        self.navigationController?.navigationBar.topItem?.title = name
    }

}
