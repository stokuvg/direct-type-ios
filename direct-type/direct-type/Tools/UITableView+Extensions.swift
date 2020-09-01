//
//  UITableView+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension UITableView {
    
    func loadCell<T: UITableViewCell>(cellName: String) -> T? {
        let name = "Xib_" + cellName
        let cell = self.dequeueReusableCell(withIdentifier: name) as! T
        
        return cell
    }
    
    
    func loadCell<T: UITableViewCell>(cellName: String, indexPath:IndexPath) -> T? {
        let name = "Xib_" + cellName
//        Log.selectLog(logLevel: .debug, "name:\(name)")
        
        let cell = self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! T        
//        Log.selectLog(logLevel: .debug, "cell:\(cell)")
        
        return cell
    }
    
    func loadHeader<T: UITableViewHeaderFooterView>(cellName: String) -> T? {
        let name = "Xib_" + cellName
        let header = self.dequeueReusableHeaderFooterView(withIdentifier: name) as! T
        
        return header
    }
    
    func registerHeaderNib(nibName:String, idName:String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        
        var name:String!
        if idName.count > 0 {
           name = "Xib_" + idName
        } else {
            name = "Xib_" + nibName
        }
        
        
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerNib(nibName:String, idName:String){
        let nib = UINib(nibName: nibName, bundle: nil)
        
        var name:String!
        if idName.count > 0 {
           name = "Xib_" + idName
        } else {
            name = "Xib_" + nibName
        }
        
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    func headerNib(nibName: String, idName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        
        var name:String!
        if idName.count > 0 {
           name = "Xib_" + idName
        } else {
            name = "Xib_" + nibName
        }
        
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
}

