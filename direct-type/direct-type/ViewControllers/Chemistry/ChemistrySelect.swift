//
//  ChemistrySelect.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class ChemistrySelect: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    typealias Score = (number: Int, score: ChemistryAnswerType)
    private var questionScores = [Score]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ChemistrySelect {
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(nibName: "ChemistrySelectCell", idName: "ChemistrySelectCell")
        questionScores = ChemistryQuestionMasterData.questions.enumerated().map({
            Score(number: $0.offset, score: .unanswered)
        })
    }
    
    func getNumber(from indexRow: Int) -> Int {
        return indexRow + 1
    }
    
    func getIndex(from number: Int) -> Int {
        return number - 1
    }
}

extension ChemistrySelect: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChemistrySelectHeaderView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChemistrySelectHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ChemistrySelectFooterView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ChemistrySelectFooterView.height
    }
}

extension ChemistrySelect: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChemistryQuestionMasterData.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.loadCell(cellName: "ChemistrySelectCell", indexPath: indexPath) as! ChemistrySelectCell
        let question = ChemistryQuestionMasterData.questions[indexPath.row]
        let number = getNumber(from: indexPath.row)
        let questionDataSet = ChemistrySelectCell.QuestionDataSet(number: number, question: question)
        cell.configure(with: questionDataSet, selectedAnswer: questionScores[indexPath.row].score, delegate: self)
        return cell
    }
}

extension ChemistrySelect: ChemistrySelectCellDelegate {
    func didSelectedAnswer(number: Int, type: ChemistryAnswerType) {
        let index = getIndex(from: number)
        questionScores[index].score = type
    }
}
