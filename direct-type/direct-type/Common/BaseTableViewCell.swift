//
//  BaseTableViewCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum PeriodType {
    case inside     // 期間内
    case outside    // 期間外
}

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func newMarkFlagCheck(startDateString: String, nowDate:Date) -> Bool {
        var retInterval:Double!
        
        let startDate = DateHelper.convStrYMD2Date(startDateString)
    //        Log.selectLog(logLevel: .debug, "startDate:\(startDate)")
        
        retInterval = nowDate.timeIntervalSince(startDate)
        
        let ret = retInterval/86400
//        Log.selectLog(logLevel: .debug, "ret:\(ret)")
        if ret < 7 {
            return true
        }
        return false
        
    }
    
    func endFlagHiddenCheck(endDateString: String, nowDate:Date) -> Bool {
        var retInterval:Double!
        
        let endDate = DateHelper.convStrYMD2Date(endDateString)
//        Log.selectLog(logLevel: .debug, "endDate:\(endDate)")
        
        retInterval = endDate.timeIntervalSince(nowDate)
        
        let ret = retInterval/86400
//        Log.selectLog(logLevel: .debug, "ret:\(ret)")
        if ret > 7 {
            return true
        }
        return false
    }

}
