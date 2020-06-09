//
//  ChemistryBusinessAvilityView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryBusinessAvilityView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
}

private extension ChemistryBusinessAvilityView {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistryBusinessAvilityView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
}
