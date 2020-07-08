//
//  Device+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/24.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class DeviceHelper {
    // 指定の端末の場合、指定してサイズを追加
    class func deviceAddHeight(defaultHeight:CGFloat,addHeight:CGFloat) -> CGFloat {
        var deviceHeight:CGFloat = defaultHeight
        
        let screenSize = UIScreen.main.bounds
//        Log.selectLog(logLevel: .debug, "screenSize.width:\(screenSize.width)")
//        Log.selectLog(logLevel: .debug, "screenSize.height:\(screenSize.height)")
        if screenSize.width >= 414 && screenSize.height >= 896 {
            deviceHeight += addHeight
        }
        
//        Log.selectLog(logLevel: .debug, "deviceHeight:\(deviceHeight)")
        return deviceHeight
    }
    
    class func xsMaxCheck() -> Bool {
        
        
        let screenSize = UIScreen.main.bounds
        if screenSize.width >= 414 && screenSize.height >= 896 {
            return true
        } else {
            return false
        }
    }
}
