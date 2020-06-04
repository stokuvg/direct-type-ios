//
//  ChemistrySelectHeaderView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistrySelectHeaderView: UIView {
    @IBOutlet private weak var whiteBackgroundView: UIView!
    
    static let height: CGFloat = 230
    private let whiteBackgroundViewCornerRadius: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setCornerRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setCornerRadius()
    }
}

private extension ChemistrySelectHeaderView {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistrySelectHeaderView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setCornerRadius() {
        whiteBackgroundView.layer.cornerRadius = whiteBackgroundViewCornerRadius
        whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
