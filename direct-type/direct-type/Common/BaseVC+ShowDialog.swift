//
//  BaseVC+ShowDialog.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/22.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import PromiseKit

extension BaseVC {
    internal enum AlertError: Error {
        case cancel
        case resumeLater
    }

    internal func showConfirm(title: String, message: String, onlyOK: Bool = false) -> Promise<Void> {
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
    

    internal func showFinishReport(title: String, message: String, completion: @escaping () -> Void) {
        self.showConfirm(title: title, message: message, onlyOK: true)
        .done { _ in
            completion()
        }
        .catch { (error) in
        }
        .finally {
        }
    }
}

