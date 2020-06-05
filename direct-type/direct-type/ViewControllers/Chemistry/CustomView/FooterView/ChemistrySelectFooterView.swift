//
//  ChemistrySelectFooterView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistrySelectFooterView: UIView {
    @IBOutlet private weak var whiteBackgroundView: UIView!
    
    static let height: CGFloat = 120
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

private extension ChemistrySelectFooterView {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistrySelectFooterView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setCornerRadius() {
        whiteBackgroundView.layer.cornerRadius = whiteBackgroundViewCornerRadius
        whiteBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
