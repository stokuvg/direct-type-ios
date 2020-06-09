//
//  ChemistryAnswerButton.swift
//  direct-type
//
//  Created by yamataku on 2020/06/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryAnswerButton: UIButton {
    
    var isAnswerSelected: Bool = false {
        didSet {
            let image = UIImage(named: isAnswerSelected ? selectedImageName : deselectedImageName)
            setImage(image, for: .normal)
        }
    }
    
    private let selectedImageName = "checkOn"
    private let deselectedImageName = "checkOff"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
}

private extension ChemistryAnswerButton {
    func setup() {
        isAnswerSelected = false
    }
}
