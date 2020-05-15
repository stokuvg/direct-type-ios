//
//  BaseFoldingHeaderView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol FoldingHeaderViewDelegate {
    func foldOpenCloseAction(tag:Int)
}

class BaseFoldingHeaderView: UIView {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var foldingMarkLabel:UILabel!
    @IBOutlet weak var headerFoldBtn:UIButton!
    @IBAction func headerOpenCloseAction() {
        self.delegate.foldOpenCloseAction(tag: self.tag)
    }
    
    var delegate:FoldingHeaderViewDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
