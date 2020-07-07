//
//  String+Extension.swift
//  direct-type
//
//  Created by yamataku on 2020/06/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

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
}

extension String {
    func replacementString(text: String, regexp: String, fixedReplacementString: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: regexp, options: [.dotMatchesLineSeparators]) else { return text }
        let results = regex.matches(in: text, options: [], range: NSRange(0 ..< text.count))
        var resultString = text
        var offset = 0
        for result in results {
            let replacementString = regex.replacementString(for: result, in: resultString, offset: offset, template: "$0")
   
            print("\t[\(replacementString)]->[\(fixedReplacementString)]")
            
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
