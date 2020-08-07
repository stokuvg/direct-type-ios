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

    @discardableResult
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

    internal func showErrorPromise(_ error: Error) -> Promise<Void> {
        let myErr: MyErrorDisp = AuthManager.convAnyError(error)
        return self.showErrorPromise(myErr)
    }
    internal func showErrorPromise(_ myErrorDisp: MyErrorDisp) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        let bufTitle = "\(myErrorDisp.title) (\(myErrorDisp.code))"
        let alert = UIAlertController.init(title: bufTitle, message: myErrorDisp.message, preferredStyle: .alert)
        //<UIView:_UIAlertControllerInterfaceActionGroupView:UIView:_UIInterfaceActionGroupHeaderScrollView:UIView> の <UILabel> が title　/　message
        let okAction = UIAlertAction.init(title: "OK", style: .default) { _ in
            resolver.fulfill(Void())
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        return promise
    }
    internal func showError(_ myErrorDisp: MyErrorDisp) {
        var isDisp: Bool = true
        switch myErrorDisp.code {
        case 401, 404, 410:
            isDisp = false
        default:
            isDisp = true
        }
        if !isDisp {
            Log.selectLog(logLevel: .error, myErrorDisp.debugDisp)
            return
        }
        self.showErrorPromise(myErrorDisp)
        .done { _ in
        }
        .catch { (error) in
        }
        .finally {
        }
    }
    internal func showError(_ error: Error) {
        let myErr: MyErrorDisp = AuthManager.convAnyError(error)
        return self.showError(myErr)
    }
//    internal func showErrorRetry(_ error: Error, errResume: ApiResumeObj) -> Promise<Void> {
//        let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//        return self.showErrorRetryPromise(myErr)
//    }
    internal func showErrorRetryPromise(_ myErrorDisp: MyErrorDisp) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        let bufTitle = "\(myErrorDisp.title) (\(myErrorDisp.code))"
        let alert = UIAlertController.init(title: bufTitle, message: myErrorDisp.message, preferredStyle: .alert)
        //<UIView:_UIAlertControllerInterfaceActionGroupView:UIView:_UIInterfaceActionGroupHeaderScrollView:UIView> の <UILabel> が title　/　message
        let retryAction = UIAlertAction.init(title: "今すぐリトライ", style: .default) { _ in
            resolver.fulfill(Void())
        }
        let resumeLaterAction = UIAlertAction.init(title: "あとでリトライ", style: .default) { _ in
            resolver.reject(AlertError.resumeLater)
        }
        let cancelAction = UIAlertAction.init(title: "キャンセル", style: .cancel) { _ in
            resolver.reject(AlertError.cancel)
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        alert.addAction(resumeLaterAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        return promise
    }
}

extension BaseVC {
    internal func showValidationError(title: String, message: String) {
//        return //!!!
        let storyboard = R.storyboard.dialog()
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_TestDialogVC") as? MyCmnDialogVC {
            var buttons: [DlgActionItem] = []
//            for item in [DlgActionType.dlgCmnBtnCancel, DlgActionType.dlgCmnBtnNG, DlgActionType.dlgCmnBtnOK] {
            for item in [DlgActionType.dlgCmnBtnOK] {
                buttons.append(DlgActionItem(action: item, completion: {
                }))
            }
            let axis: DlgDetail.AxisType = .horizontal //ボタンは縦横の指定が可能
            let dlgItem: DlgDetail = DlgDetail(title: title, message: message, buttons: buttons, axisType: axis)
            nvc.initData(item: dlgItem)
            //遷移アニメーション関連
            nvc.modalTransitionStyle = .crossDissolve
            self.present(nvc, animated: true) {
            }
        }
    }
}
