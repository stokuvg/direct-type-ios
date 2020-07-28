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
    case help
    case privacy
    case term
    case approachExplanation
    case accountPrivacyPolicy
    case accountAgreements
    case accountPhoneReason
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
        case .none:
            title = ""
            urlString = ""

        case .help:
            title = DirectTypeLinkURL.SettingsFAQ.dispText
            urlString = DirectTypeLinkURL.SettingsFAQ.urlText
        case .privacy:
            title = DirectTypeLinkURL.SettingsPrivacyPolicy.dispText
            urlString = DirectTypeLinkURL.SettingsPrivacyPolicy.urlText
        case .term:
            title = DirectTypeLinkURL.SettingsAgreement.dispText
            urlString = DirectTypeLinkURL.SettingsAgreement.urlText

        case .approachExplanation:
            title = DirectTypeLinkURL.AproachAbout.dispText
            urlString = DirectTypeLinkURL.AproachAbout.urlText
            
        case .accountPrivacyPolicy:
            title = DirectTypeLinkURL.RegistPrivacyPolicy.dispText
            urlString = DirectTypeLinkURL.RegistPrivacyPolicy.urlText
        case .accountAgreements:
            title = DirectTypeLinkURL.RegistAgreement.dispText
            urlString = DirectTypeLinkURL.RegistAgreement.urlText
        case .accountPhoneReason:
            title = DirectTypeLinkURL.RegistPhoneReason.dispText
            urlString = DirectTypeLinkURL.RegistPhoneReason.urlText
        }
        
        self.tmpNavigationBar.topItem?.title = title
        self.tmpNavigationBar.backgroundColor = .blue
        self.tmpNavigationBar.topItem?.titleView?.backgroundColor = .yellow

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
