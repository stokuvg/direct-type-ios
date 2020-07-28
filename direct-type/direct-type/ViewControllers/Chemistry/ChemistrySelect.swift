//
//  ChemistrySelect.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import PromiseKit
import SVProgressHUD

class ChemistrySelect: BaseChemistryVC {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonBackgroundView: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: UIButton) {
        guard currnetAnswerState == .complete else { return }
        postChemistryData()
    }
    
    enum SelectedAnswerType {
        case incomplete
        case complete
        case allNo
    }
    
    private var questionScores = [ChemistryScore]()
    
    private var currnetAnswerState: SelectedAnswerType {
        if questionScores.filter({ $0.selectedAnswer == .no }).count == questionScores.count {
            return .allNo
        }
        if questionScores.filter({ $0.selectedAnswer != .unanswered }).count == questionScores.count  {
            return .complete
        }
        return .incomplete
    }
    
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
            ChemistryScore(questionNumber: $0.offset, personalType: $0.element.type, selectedAnswer: .unanswered)
        })
        setShadowAndRadius()
        changeButtonImage()
    }
    
    func getNumber(from indexRow: Int) -> Int {
        return indexRow + 1
    }
    
    func getIndex(from number: Int) -> Int {
        return number - 1
    }
    
    func setShadowAndRadius() {
        buttonBackgroundView.layer.cornerRadius = buttonBackgroundView.bounds.height / 2
        buttonBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        buttonBackgroundView.layer.shadowOpacity = 0.3
        buttonBackgroundView.layer.shadowRadius = 5
        buttonBackgroundView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func changeButtonImage() {
        switch currnetAnswerState {
        case .incomplete:
            let remainingCount = questionScores.filter({ $0.selectedAnswer == .unanswered }).count
            nextButton.setTitle("残り\(remainingCount)問", for: .normal)
            nextButton.setTitleColor(.lightGray, for: .normal)
            buttonBackgroundView.backgroundColor = .white
        case .complete:
            nextButton.setTitle("結果を見る", for: .normal)
            nextButton.setTitleColor(.white, for: .normal)
            buttonBackgroundView.backgroundColor = UIColor(colorType: .color_button)
        case .allNo:
            nextButton.setTitle("「いいえ」以外も選択してください。", for: .normal)
            nextButton.setTitleColor(.lightGray, for: .normal)
            buttonBackgroundView.backgroundColor = .white
        }
        
    }
    
    func postChemistryData() {
        let topRanker = ChemistryScoreCalculation(questionScores: questionScores).topThree
        let ids = [topRanker.first, topRanker.second, topRanker.third].compactMap({ $0 }).map({ String($0.rawValue) })
        let parameter = CreateChemistryRequestDTO(chemistryTypeIds: ids)
        SVProgressHUD.show()
        ApiManager.createChemistry(parameter, isRetry: true)
        .done { result in
            ApiManager.shared.dicLastUpdate[.topRanker] = Date(timeIntervalSince1970: 0)//モデル更新したので、一覧再取得が必要
            self.transitionToChemisrortResult()
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showConfirm(title: "データ送信エラー", message: myErr.message, onlyOK: true)
        }
        .finally {
            SVProgressHUD.dismiss()
        }
    }
    
    func transitionToChemisrortResult() {
        let vc = UIStoryboard(name: "ChemistryResult", bundle: nil)
            .instantiateInitialViewController() as! ChemistryResult
        vc.configure(with: questionScores)
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
        cell.configure(with: questionDataSet, selectedAnswer: questionScores[indexPath.row].selectedAnswer, delegate: self)
        return cell
    }
}

extension ChemistrySelect: ChemistrySelectCellDelegate {
    func didSelectedAnswer(number: Int, type: ChemistryAnswerType) {
        let index = getIndex(from: number)
        questionScores[index].selectedAnswer = type
        changeButtonImage()
    }
}
