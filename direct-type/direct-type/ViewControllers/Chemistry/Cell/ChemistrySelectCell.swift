//
//  ChemistrySelectCell.swift
//  direct-type
//
//  Created by yamataku on 2020/06/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol ChemistrySelectCellDelegate: class {
    func didSelectedAnswer(number: Int, type: ChemistryAnswerType)
}

final class ChemistrySelectCell: UITableViewCell {
    @IBOutlet private weak var questionNumberLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    // 回答ボタン
    @IBOutlet private weak var noButton: ChemistryAnswerButton!
    @IBOutlet private weak var IfAnythingNoButton: ChemistryAnswerButton!
    @IBOutlet private weak var IfAnythingYes: ChemistryAnswerButton!
    @IBOutlet private weak var yesButton: ChemistryAnswerButton!
    @IBOutlet var answerTitleLabels: [UILabel]!
    @IBAction func noButton(_ sender: UIButton) {
        selectedAnswer = .no
        delegate?.didSelectedAnswer(number: number!, type: selectedAnswer)
    }
    @IBAction func IfAnythingNoButton(_ sender: UIButton) {
        selectedAnswer = .ifAnythingsNo
        delegate?.didSelectedAnswer(number: number!, type: selectedAnswer)
    }
    @IBAction func IfAnythingYes(_ sender: UIButton) {
        selectedAnswer = .ifAnythingsYes
        delegate?.didSelectedAnswer(number: number!, type: selectedAnswer)
    }
    @IBAction func yesButton(_ sender: UIButton) {
        selectedAnswer = .yes
        delegate?.didSelectedAnswer(number: number!, type: selectedAnswer)
    }
    
    typealias QuestionDataSet = (number: Int, question: ChemistryQuestion)
    
    private var selectedAnswer = ChemistryAnswerType.unanswered {
        didSet {
            noButton.isAnswerSelected = selectedAnswer == .no
            IfAnythingNoButton.isAnswerSelected = selectedAnswer == .ifAnythingsNo
            IfAnythingYes.isAnswerSelected = selectedAnswer == .ifAnythingsYes
            yesButton.isAnswerSelected = selectedAnswer == .yes
        }
    }
    
    private weak var delegate: ChemistrySelectCellDelegate?
    private var number: Int? = nil {
        didSet {
            questionNumberLabel.text = String(number!) + "."
        }
    }
    private var question: ChemistryQuestion? = nil {
        didSet {
            questionLabel.text = question!.contentText
        }
    }

    func configure(with dataSet: QuestionDataSet, selectedAnswer: ChemistryAnswerType, delegate: ChemistrySelectCellDelegate) {
        number = dataSet.number
        question = dataSet.question
        self.delegate = delegate
        self.selectedAnswer = selectedAnswer
        setFont()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

private extension ChemistrySelectCell {
    func setFont() {
        questionNumberLabel.font = UIFont(fontType: .font_Sb)
        questionLabel.font = UIFont(fontType: .font_Sb)
        answerTitleLabels.forEach({ label in
            // TODO: font-SSSの定義確認後に適用する
            // label.font = UIFont(fontType: .font_SS)
        })
    }
}
