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
