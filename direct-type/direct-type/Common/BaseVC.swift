//
//  BaseVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

import PromiseKit
import SVProgressHUD

enum NaviType {
    case normal
    case login
    case detail
    case share
}

class BaseVC: UIViewController {
    
    var moreDataCount:Int = 20 // もっと見る 件数
    
    private var statusBarStyle: UIStatusBarStyle = .default

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 画面タップ不可設定
        SVProgressHUD.setDefaultMaskType(.black)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)

        initNotify()//通知登録（画面遷移でも残すもの）
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewWillAppear start")
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arDefaultWhite")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arDefaultWhite")
        
        if #available(iOS 13.0, *) {
            self.setStattusBarStyle(style: .darkContent)
        } else {
            self.navigationController?.navigationBar.barStyle = .black
        }
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
            navBarAppearance.largeTitleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
            navBarAppearance.backgroundColor = UIColor.init(colorType: .color_black)
            self.navigationController?.navigationBar.tintColor = UIColor.init(colorType: .color_white)
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            
            self.navigationController?.navigationBar.tintColor = UIColor.init(colorType: .color_white)
            self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_black)
            self.navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
        }
        addNotify()//通知登録（画面遷移で消すもの）
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewDidAppear start")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewWillDisappear start")

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arDefaultWhite")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arDefaultWhite")
        removeNotify()//通知解除（画面遷移で消すもの）
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewDidDisappear start")
    }
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    func initNotify() {
    }
    // この画面に遷移したときに登録するもの
    func addNotify() {
    }
    // 他の画面に遷移するときに消して良いもの
    func removeNotify() {
    }

    func setStattusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func linesTitle(date:String,title:String) {
        
        let dateAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.init(colorType: .color_white) as Any,
            .font : UIFont.init(fontType: .C_font_SSb) as Any
        ]
        var parentDate:String = ""
        if date.count > 0 {
            parentDate = "(" + date + ")"
        }
        let dateString = NSAttributedString(string: parentDate, attributes: dateAttributes)
        
        let paragraphAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.init(colorType: .color_white) as Any,
            .font : UIFont.init(name: "HiraginoSans-W3", size: 6.0) as Any
        ]
//        let paragraphString = NSAttributedString(string: "\n\n", attributes: paragraphAttributes)
        let paragraphString = NSAttributedString(string: " ", attributes: paragraphAttributes)
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.init(colorType: .color_white) as Any,
            .font : UIFont.init(fontType: .C_font_M) as Any
        ]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let mutableString = NSMutableAttributedString()
        
//        mutableString.append(dateString)
//        mutableString.append(paragraphString)
        mutableString.append(titleString)
        mutableString.append(paragraphString)
        mutableString.append(dateString)
        
        let naviX:CGFloat = 25
        let naviY:CGFloat = 0
        let width = (self.navigationController?.navigationBar.bounds.size.width)! - 25
        let naviW:CGFloat = width
        let naviH:CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: naviX, y: naviY, width: naviW, height: naviH)
                
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.attributedText = mutableString
        self.navigationItem.titleView = titleLabel
    }
    
    //
    func setRightSearchBtn() {
        let searchImage = UIImage(named: "refineDefaultWhiteBase")
        let searchItemBtn = UIBarButtonItem.init(image: searchImage, style: .done, target: self, action: #selector(searchBtnAction))
        
        self.navigationItem.rightBarButtonItem = searchItemBtn
    }
    
    @objc func searchBtnAction() {
        
    }
    
    func getVC<T: UIViewController>(sbName:String,vcName:String) -> T? {
            
        let sb = UIStoryboard(name: sbName, bundle: nil)
            
        let sbid = "Sbid_" + vcName
            
        let vc = sb.instantiateViewController(withIdentifier: sbid) as! T
        return vc
    }

}

extension BaseVC {
    
}
