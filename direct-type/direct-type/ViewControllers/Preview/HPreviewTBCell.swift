//
//  HPreviewTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MdlItemH {
    var title: String = ""
    var value: String = ""
    var notice: String = ""
    
    convenience init(_ title: String, _ value: String, notice: String = "") {
        self.init()
        self.title = title
        self.value = value
        self.notice = notice
    }
        
    var debugDisp: String {
        return "[\(title)] [\(value)]（\(notice)）"
    }
}

class HPreviewTBCell: UITableViewCell {
    var item: MdlItemH? = nil
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblNotice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(_ item: MdlItemH) {
        self.item = item
    }
    
    func dispCell() {
        guard let _item = item else { return }
        lblTitle.text = _item.title
        lblValue.text = _item.value
        lblNotice.text = _item.notice
        if _item.notice == "" {
            lblNotice.isHidden = true
        } else {
            lblNotice.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
