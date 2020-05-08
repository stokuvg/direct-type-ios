//
//  JobOfferDetailVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

open class FullSizeNavigationBar: UINavigationBar {
    open override func layoutSubviews() {
        super.layoutSubviews()
        items?
            .compactMap { ($0.titleView as! NaviButtonsView) }
            .filter {$0.superview != nil}
            .forEach { titleView in
                titleView.frame = self.bounds
        }
    }
}

class JobOfferDetailVC: TmpBasicVC {
    
    @IBOutlet weak var detailTableView:UITableView!
    
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
        
        Log.selectLog(logLevel: .debug, "titleView:\(String(describing: self.navigationItem.titleView))")
        Log.selectLog(logLevel: .debug, "navigationBar:\(String(describing: self.navigationController?.navigationBar))")
    }
    
}

extension JobOfferDetailVC: UITableViewDelegate {
    
}

extension JobOfferDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
