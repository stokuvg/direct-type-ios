//
//  ChemistrySelectCell.swift
//  direct-type
//
//  Created by yamataku on 2020/06/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistrySelectCell: UITableViewCell {
    @IBOutlet private weak var questionNumberLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    // 回答ボタン
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var IfAnythingNoButton: UIButton!
    @IBOutlet private weak var IfAnythingYes: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBAction func noButton(_ sender: UIButton) {
        selectedAnswer = .no
    }
    @IBAction func IfAnythingNoButton(_ sender: UIButton) {
        selectedAnswer = .ifAnythingsNo
    }
    @IBAction func IfAnythingYes(_ sender: UIButton) {
        selectedAnswer = .ifAnythingsYes
    }
    @IBAction func yesButton(_ sender: UIButton) {
        selectedAnswer = .yes
    }
    
    enum AnswerType {
        case no
        case ifAnythingsNo
        case ifAnythingsYes
        case yes
        case unanswered
    }
    
    private var selectedAnswer = AnswerType.unanswered {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
