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

extension String {
    enum CountryCodeType {
        case japan
        
        var text: String {
            switch self {
            case .japan:
                return "+81"
            }
        }
    }
    
    func addCountryCode(type: CountryCodeType) ->  String {
        return CountryCodeType.japan.text + dropFirst()
    }
    
    var withHyphen: String {
        let mutableString = NSMutableString(string: self)
        mutableString.insert("-", at: 3)
        mutableString.insert("-", at: 8)
        return String(mutableString)
    }
    
    var isNumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^0[7-9]0[0-9]{8}").evaluate(with: self)
    }
}

extension String {
    func replacementString(text: String, regexp: String, fixedReplacementString: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: regexp, options: [.dotMatchesLineSeparators]) else { return text }
        let results = regex.matches(in: text, options: [], range: NSRange(0 ..< text.count))
        var resultString = text
        var offset = 0
        for result in results {
            let replacementString = regex.replacementString(for: result, in: resultString, offset: offset, template: "$0")
            var range = result.range(at: 0)
            range.location += offset
            let start = resultString.index(resultString.startIndex, offsetBy: range.location)
            let end = resultString.index(start, offsetBy: range.length)
            resultString = resultString.replacingCharacters(in: start..<end, with: fixedReplacementString)
            offset += fixedReplacementString.count - range.length
        }
        return resultString
    }
}
