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
}

extension ChemistrySelect: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.loadCell(cellName: "ChemistrySelectCell", indexPath: indexPath) as! ChemistrySelectCell
        return cell
    }
}
