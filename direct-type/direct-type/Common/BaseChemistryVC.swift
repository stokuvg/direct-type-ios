//
//  BaseChemistryVC.swift
//  direct-type
//
//  Created by yamataku on 2020/07/10.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import PromiseKit

class BaseChemistryVC: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    @discardableResult
    func showConfirm(title: String, message: String, onlyOK: Bool = false) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()

        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { _ in
            resolver.fulfill(Void())
        }
        alert.addAction(okAction)
        if onlyOK == false {
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { _ in
                resolver.reject(AlertError.cancel)
            }
            alert.addAction(cancelAction)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        return promise
    }
    
    func getVC<T: UIViewController>(sbName:String,vcName:String) -> T? {
            
        let sb = UIStoryboard(name: sbName, bundle: nil)
            
        let sbid = "Sbid_" + vcName
            
        let vc = sb.instantiateViewController(withIdentifier: sbid) as! T
        return vc
    }
}

private extension BaseChemistryVC {
    enum AlertError: Error {
        case cancel
        case resumeLater
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.init(colorType: .color_sub)!
            navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_sub)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}
