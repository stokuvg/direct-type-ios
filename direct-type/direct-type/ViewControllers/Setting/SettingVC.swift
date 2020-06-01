//
//  SettingVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingVC: TmpBasicVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "設定"
        
        tableView.backgroundColor = UIColor.init(colorType: .color_white)!
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    

}

extension SettingVC: UITableViewDelegate {
    
}

extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.init(colorType: .color_white)
        return cell
    }
    
    
}
