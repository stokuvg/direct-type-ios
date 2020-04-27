//
//  BasePresentVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class BasePresentVC: BaseVC {
    @IBOutlet weak var tmpNavigationBar:UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tmpNavigationBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Modalを閉じるボタンを表示
    func leftCloseDisp() {
        let closeBtn = UIBarButtonItem.init(image: UIImage(named: "close"), style: .done, target: self, action: #selector(leftCloseBtnAction))
        self.navigationItem.leftBarButtonItem = closeBtn
        
        let naviItem = UINavigationItem(title: "")
        naviItem.leftBarButtonItem = closeBtn
        tmpNavigationBar.pushItem(naviItem, animated: true)
    }
    
    /// @objc
    @objc func leftCloseBtnAction() {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension BasePresentVC: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
