//
//  ChemistryResult.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryResult: BaseChemistryVC {
    @IBOutlet private weak var tableView: UITableView!
    
    private var topRanker: ChemistryScoreCalculation.TopRanker?
    private let tableViewEstimateCellHeight: CGFloat = 330
    private var isExistsData = false
    private var resultCellCount: Int {
        // 1位のセルとビジネスアビリティセルはデフォルト表示
        var cellCount = 2
        cellCount += topRanker!.second == nil ? 0 : 1
        cellCount += topRanker!.third == nil ? 0 : 1
        return cellCount
    }
    
    private enum IndicateCellType: Int, CaseIterable {
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
        topRanker = ChemistryScoreCalculation(questionScores: scores).topThree
    }
    
    func configure(with topRanker: ChemistryScoreCalculation.TopRanker) {
        self.topRanker = topRanker
        isExistsData = true
    }
}

private extension ChemistryResult {
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.registerNib(nibName: "ChemistryResultPersonalTypeCell", idName: "ChemistryResultPersonalTypeCell")
        tableView.registerNib(nibName: "ChemistryBusinessAbilityCell", idName: "ChemistryBusinessAbilityCell")
        tableView.estimatedRowHeight = tableViewEstimateCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        navigationItem.hidesBackButton = !isExistsData
    }
    
    func getAvarageAvilityScore() -> BusinessAvilityScore {
        let topScore = [topRanker!.first, topRanker!.second, topRanker!.third].compactMap({$0})
        let quickAction = getAvarage(from: topScore.map({ $0.avilityScore.quickAction }))
        let toughness = getAvarage(from: topScore.map({ $0.avilityScore.toughness }))
        let spiritOfChallenge = getAvarage(from: topScore.map({ $0.avilityScore.spiritOfChallenge }))
        let logical = getAvarage(from: topScore.map({ $0.avilityScore.logical }))
        let leadership = getAvarage(from: topScore.map({ $0.avilityScore.leadership }))
        let dedicationAndSupport = getAvarage(from: topScore.map({ $0.avilityScore.dedicationAndSupport }))
        let cooperativeness = getAvarage(from: topScore.map({ $0.avilityScore.cooperativeness }))
        let initiative = getAvarage(from: topScore.map({ $0.avilityScore.initiative }))
        let creativityAndIdea = getAvarage(from: topScore.map({ $0.avilityScore.creativityAndIdea }))
        let responsibilityAndSteadiness = getAvarage(from: topScore.map({ $0.avilityScore.responsibilityAndSteadiness }))
        return BusinessAvilityScore(quickAction: quickAction, toughness: toughness, spiritOfChallenge: spiritOfChallenge, logical: logical, leadership: leadership, dedicationAndSupport: dedicationAndSupport, cooperativeness: cooperativeness, initiative: initiative, creativityAndIdea: creativityAndIdea, responsibilityAndSteadiness: responsibilityAndSteadiness)
    }
    
    func getAvarage(from array: [Double]) -> Double {
        let molecule = array.reduce(0, +)
        let denominator = Double(array.count)
        return molecule / denominator
    }
    
    func transitionToChemisrortSelect() {
        let vc = UIStoryboard(name: "ChemistrySelect", bundle: nil)
            .instantiateInitialViewController() as! ChemistrySelect
        hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChemistryResult: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChemistryResultHeader()
        header.configure(with: topRanker!)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChemistryResultHeader.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ChemistryResultFooterView()
        footer.configure(isExistsDat: isExistsData, delegate: self)
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
        let indicateCellTypes = IndicateCellType.allCases.filter({
            if topRanker?.second == nil && $0 == .secondPlaceResult { return false }
            if topRanker?.third == nil && $0 == .thirdPlaceResult { return false }
            return true
        })
        let indicateCellType = indicateCellTypes[indexPath.row]
        
        switch indicateCellType {
        case .firstPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topRanker!.first)
            return cell
        case .secondPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topRanker!.second)
            return cell
        case .thirdPlaceResult:
            let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
            cell.configure(with: topRanker!.third)
            return cell
        case .businessAbility:
            let cell = tableView.loadCell(cellName: "ChemistryBusinessAbilityCell", indexPath: indexPath) as! ChemistryBusinessAbilityCell
            cell.configure(with: getAvarageAvilityScore())
            return cell
        }
    }
}

extension ChemistryResult: ChemistryResultFooterViewDelegate {
    func didTapCompleteButton() {
        if isExistsData {
            transitionToChemisrortSelect()
        } else {
            hidesBottomBarWhenPushed = false//下部のTabBarを遷移時に表示にする
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
