//
//  String+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension String {
    func paragraphElimination() -> String {
        let componentText = self.components(separatedBy: .newlines)
        
        var singleText:String = ""
        for i in 0..<componentText.count {
            let _text = componentText[i]
            singleText += _text
        }
        return singleText
    }
}
