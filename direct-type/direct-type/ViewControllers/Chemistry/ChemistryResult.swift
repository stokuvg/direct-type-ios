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
        
        let ranking = ChemistryScoreCalculation(questionScores: questionScores).ranking
        ranking.forEach({ rank in
            print("👀Ranking: \(rank.rank)位、 スコア: \(rank.score), タイプ: \(rank.personalType.rawValue)")
            
        })
    }
}

extension ChemistryResult: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChemistryResultHeader()
        let ranking = ChemistryScoreCalculation(questionScores: questionScores).ranking
        header.configure(with: ranking)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChemistryResultHeader.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ChemistrySelectFooterView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ChemistrySelectFooterView.height
    }
}

extension ChemistryResult: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
