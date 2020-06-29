//
//  EntryFormExQuestionsItemTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/29.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormExQuestionsItemTBCell: UITableViewCell {
    var entry: MdlEntry? = nil

    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwQuestionArea: UIView!
    @IBOutlet weak var lblQuestion1: UILabel!
    @IBOutlet weak var tfAnswaer1: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
