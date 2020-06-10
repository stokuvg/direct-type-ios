//
//  ChemistryResult.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryResult: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var questionScores = [ChemistryScore]()
    private let tableViewEstimateCellHeight: CGFloat = 330
    private var resultCellCount: Int {
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        // 1位のセルとビジネスアビリティセルはデフォルト表示
        var cellCount = 2
        cellCount += topThree.second == nil ? 0 : 1
        cellCount += topThree.third == nil ? 0 : 1
        return cellCount
    }
    
    private enum IndicateCellType: Int {
        case firstPlaceResult
        case secondPlaceResult
        case thirdPlaceResult
        case businessAbility
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(with scores: [ChemistryScore]) {
        questionScores = scores
    }
}

private extension ChemistryResult {
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(nibName: "ChemistryResultPersonalTypeCell", idName: "ChemistryResultPersonalTypeCell")
        tableView.registerNib(nibName: "ChemistryBusinessAbilityCell", idName: "ChemistryBusinessAbilityCell")
        tableView.estimatedRowHeight = tableViewEstimateCellHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getAvarageAvilityScore() -> BusinessAvilityScore {
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        let topScore = [topThree.first, topThree.second, topThree.third].compactMap({$0})
        let quickAction = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let toughness = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let spiritOfChallenge = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let logical = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let leadership = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let dedicationAndSupport = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let cooperativeness = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let initiative = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let creativityAndIdea = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let responsibilityAndSteadiness = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        return BusinessAvilityScore(quickAction: quickAction, toughness: toughness, spiritOfChallenge: spiritOfChallenge, logical: logical, leadership: leadership, dedicationAndSupport: dedicationAndSupport, cooperativeness: cooperativeness, initiative: initiative, creativityAndIdea: creativityAndIdea, responsibilityAndSteadiness: responsibilityAndSteadiness)
    }
    
    func getAvarage(from array: [Double]) -> Double {
        let molecule = array.reduce(0, +)
        let denominator = Double(array.count)
        return molecule / denominator
    }
}

extension ChemistryResult: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChemistryResultHeader()
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        header.configure(with: topThree)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChemistryResultHeader.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ChemistryResultFooterView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ChemistryResultFooterView.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let avilityCell = cell as? ChemistryBusinessAbilityCell {
            avilityCell.setLayout()
        }
    }
}

extension ChemistryResult: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        let indicateCellType = IndicateCellType(rawValue: indexPath.row)!
        switch indicateCellType {
        case .firstPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topThree.first)
            return cell
        case .secondPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topThree.second)
            return cell
        case .thirdPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topThree.third)
            return cell
        case .businessAbility:
            let cell = tableView.loadCell(cellName: "ChemistryBusinessAbilityCell", indexPath: indexPath) as! ChemistryBusinessAbilityCell
            cell.configure(with: getAvarageAvilityScore())
            return cell
        }
    }
}
