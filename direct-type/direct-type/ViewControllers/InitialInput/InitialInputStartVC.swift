//
//  InitialInputStartVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/10.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol InitialSlideViewDelegate {
    func delegateSliderBtnHiddenCheck()
}

class InitialSlideView: UIView {
    
    @IBOutlet weak var scrollBackView: UIView!
    var scrollView: UIScrollView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    var imageNo:Int = 0
    
    var delegate:InitialSlideViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: scrollBackView.frame.size.width, height: scrollBackView.frame.size.height))
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.scrollBackView.addSubview(scrollView)
    }
    
    func setup(images:[UIImage]) {
        self.clearCheck()
        
        let width = self.scrollView.bounds.size.width
        let height = self.scrollView.bounds.size.height
        var x:CGFloat = 0
        for i in 0..<images.count {
            let image = images[i]
            let imageView = UIImageView.init(frame: CGRect(x: x, y: 0, width: width, height: height))
            imageView.backgroundColor = UIColor.clear
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            self.scrollView.addSubview(imageView)
            x += width
        }
        scrollView.contentSize = CGSize(width: x, height: height)
        
        pageControl.numberOfPages = images.count
    }
    
    func changeScrollViewSize(size: CGSize) {
        var scrollViewFrame = self.scrollView.frame
        scrollViewFrame.size = size
        self.scrollView.frame = scrollViewFrame
    }
    
    private func clearCheck() {
        for _item in self.scrollView.subviews {
            if _item is UIImageView {
                _item.removeFromSuperview()
            }
        }
    }
    
    func changePageViewAction() {
        let changeContentX:CGFloat = CGFloat(Int(self.scrollView.frame.size.width) * imageNo)
        self.scrollView.setContentOffset(CGPoint(x: changeContentX, y: 0), animated: true)
    }
}
extension InitialSlideView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let checkX = scrollView.contentOffset.x / scrollView.frame.size.width
        
        let pageNo = Int(checkX)
        self.pageControl.currentPage = pageNo
        
        imageNo = pageNo
        
        self.delegate.delegateSliderBtnHiddenCheck()
    }
}

class InitialInputStartVC: TmpBasicVC {
    
    @IBOutlet weak var topSpaceView:UIView!
    
    @IBOutlet weak var initialSlideView:InitialSlideView!
    @IBOutlet weak var leftSlideBtn:UIButton!
    @IBAction func leftSlideAction() {
        self.backImageAction()
    }
    @IBOutlet weak var rightSlideBtn:UIButton!
    @IBAction func rightSlideAction() {
        self.forwardImageAction()
    }
    
    
    @IBOutlet weak var registBtn:UIButton!
    @IBAction func registAction() {
        // TODO: 登録画面へ移動
        let vc = getVC(sbName: "InitialInputRegistVC", vcName: "InitialInputRegistVC") as! InitialInputRegistVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var loginBackView: UIView!
    @IBOutlet weak var loginedLabel:UILabel!
    @IBOutlet weak var loginBtn:UIButton!
    @IBAction func loginAction() {
        let vc = getVC(sbName: "LoginVC", vcName: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var bottomSpaceView:UIView!
    
    var images:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(colorType: .color_sub)
        
        self.initialSlideView.delegate = self
        
        let img01 = UIImage(named: "img01")!
        
        images = [
            img01,
            img01,
            img01,
            img01,
        ]
        
        self.registBtn.setTitle(text: "利用を始める", fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        self.loginedLabel.text(text: "すでにアカウントをお持ちの方", fontType: .font_SS, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.initialSlideView.changeScrollViewSize(size:self.initialSlideView.frame.size)
        self.initialSlideView.setup(images: images)
        
        self.slideBtnHiddenCheck()
    }
    
    private func slideBtnHiddenCheck() {
        if initialSlideView.imageNo == 0 {
            self.leftSlideBtn.isHidden = true
        } else if initialSlideView.imageNo == (images.count-1) {
            self.rightSlideBtn.isHidden = true
        } else {
            self.leftSlideBtn.isHidden = false
            self.rightSlideBtn.isHidden = false
        }
    }
    
    private func backImageAction() {
        self.initialSlideView.imageNo -= 1
        if self.initialSlideView.imageNo < 0 {
            self.initialSlideView.imageNo = 0
        }
        self.initialSlideView.changePageViewAction()
        self.slideBtnHiddenCheck()
    }
    
    private func forwardImageAction() {
        self.initialSlideView.imageNo += 1
        if (self.images.count-1) < self.initialSlideView.imageNo {
            self.initialSlideView.imageNo = (self.images.count-1)
        }
        self.initialSlideView.changePageViewAction()
        self.slideBtnHiddenCheck()
    }

}

extension InitialInputStartVC: InitialSlideViewDelegate {
    func delegateSliderBtnHiddenCheck() {
//        self.initialSlideView.changePageViewAction()
        self.slideBtnHiddenCheck()
    }
}
