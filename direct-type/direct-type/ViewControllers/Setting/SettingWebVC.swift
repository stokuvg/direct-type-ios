//
//  SettingWebVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import WebKit

enum SettingWebType {
    case none
    case Help
    case Privacy
    case Term
    case approachExplanation
    case reasonOfConfirmPhone
}

class SettingWebVC: TmpWebVC {
    
    @IBOutlet weak var settingWeb:WKWebView!
    @IBOutlet weak var backItem:UIBarButtonItem!
    @IBOutlet weak var forwardItem:UIBarButtonItem!
    
    var _type:SettingWebType!

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.selectLog(logLevel: .debug, "SettingWebVC viewDidLoad start")
        // Do any additional setup after loading the view.
        self.tmpNavigationBar.barTintColor = UIColor.init(colorType: .color_white)
        self.itemSetting()
        self.viewSetting()
    }
    
    private func itemSetting() {
        self.backItem.isEnabled = false
        self.backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_base)!], for: .normal)
        self.backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_main)!], for: .disabled)
        self.backItem.tintColor = UIColor.init(colorType: .color_base)!
        self.backItem.action = #selector(webBackAction)
        self.forwardItem.isEnabled = false
        self.forwardItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_base)!], for: .normal)
        self.forwardItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(colorType: .color_main)!], for: .disabled)
        self.forwardItem.tintColor = UIColor.init(colorType: .color_base)!
        self.forwardItem.action = #selector(webForwardAction)
    }
    
    private func viewSetting() {
        
        var title = ""
        var urlString:String = ""
        guard let _type = _type else { return }
        switch _type {
        case .Help:
            title = "よくある質問・ヘルプ"
            urlString = "https://type.jp/help/index.html"
        case .Privacy:
            title = "プライバシーポリシー"
            urlString = "https://type.jp/s/kojin/"
        case .Term:
            title = "利用規約"
            urlString = "https://type.jp/help/category_14.html"
        case .none:
            title = ""
            urlString = ""
        case .approachExplanation:
            title = ""
            urlString = ""
        case .reasonOfConfirmPhone:
            title = ""
            urlString = ""
        }
        
        self.tmpNavigationBar.topItem?.title = title
        settingWeb.navigationDelegate = self
        settingWeb.uiDelegate = self
        
        if urlString.count > 0 {
            let request = URLRequest.init(url: URL(string: urlString)!)
            settingWeb.load(request)
        }
    }
    
    func setup(type:SettingWebType) {
        Log.selectLog(logLevel: .debug, "SettingWebVC setup start")
        
        _type = type
    }
    
    @objc func webBackAction() {
        self.settingWeb.goBack()
    }
    
    @objc func webForwardAction() {
        self.settingWeb.goForward()
    }

}

extension SettingWebVC: WKUIDelegate {
}

extension SettingWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.backItem.isEnabled = webView.canGoBack ? true : false
        self.forwardItem.isEnabled = webView.canGoForward ? true : false
    }
}
