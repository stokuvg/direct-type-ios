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
    private let secondPlaceCellIndex = 1
    private let thirdPlaceCellIndex = 2
    private let tableViewEstimateCellHeight: CGFloat = 330
    private var resultCellCount: Int {
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        // 1位のセルとビジネスアビリティセルはデフォルト表示
        var cellCount = 2
        cellCount += topThree.second == nil ? 0 : 1
        cellCount += topThree.third == nil ? 0 : 1
        return cellCount
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
        tableView.estimatedRowHeight = tableViewEstimateCellHeight
        tableView.rowHeight = UITableView.automaticDimension
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
}

extension ChemistryResult: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.loadCell(cellName: "ChemistryResultPersonalTypeCell", indexPath: indexPath) as! ChemistryResultPersonalTypeCell
        let topThree = ChemistryScoreCalculation(questionScores: questionScores).topThree
        switch indexPath.row {
        case secondPlaceCellIndex:
            cell.configure(with: topThree.second)
        case thirdPlaceCellIndex:
            cell.configure(with: topThree.third)
        default:
            cell.configure(with: topThree.first)
        }
        return cell
    }
}
