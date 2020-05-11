//
//  JobDetailDataCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

class JobDetailDataCell: UITableViewCell {
    
    @IBOutlet weak var dataStackView:UIStackView!
    
    // 終了間近,スカウト
    @IBOutlet weak var imminetAndScountBackView:UIView!
    // 職種名
    @IBOutlet weak var jobCategoryBackView:UIView!
    // 給与
    @IBOutlet weak var salaryBackView:UIView!
    // 勤務地
    @IBOutlet weak var workPlaceBackView:UIView!
    // 社名
    @IBOutlet weak var companyBackView:UIView!
    // 掲載期限
    @IBOutlet weak var limitBackView:UIView!
    // メイン画像
    @IBOutlet weak var mainImageBackView:UIView!
    @IBOutlet weak var mainImagesScrollView:UIScrollView!
    // 画像複数
    @IBOutlet weak var mainImagesPageControlBackView:UIView!
    @IBOutlet weak var mainImagesControl:UIPageControl!
    
    var viewWidth:CGFloat!
    var viewHeight:CGFloat!
    var imageX:CGFloat!
    var imageY:CGFloat!
    var imageW:CGFloat!
    var imageH:CGFloat!
    
    var margin:CGFloat = 15
    
    var cellWidth:CGFloat = 0
    
    var images:[UIImage] = []
    var imageViews:[UIImageView] = []
    
    var imageCnt:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
        
        self.mainImagesScrollView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellWidth(width:CGFloat) {
        cellWidth = width
        
        viewWidth = cellWidth
        viewHeight = self.mainImageBackView.frame.size.height
        
        imageW = viewWidth - (margin * 2)
        imageH = imageW*8/11
        imageY = (viewHeight - imageH)/2
        imageX = margin
    }
    
    func setup(data:[String:Any]) {
        
        // 画像セット
        let imageUrls:[String] = data["images"] as! [String]
        Log.selectLog(logLevel: .debug, "imageUrls:\(imageUrls)")
        imageCnt = imageUrls.count
        if imageUrls.count > 1 {
            
            self.mainImagesControl.numberOfPages = imageUrls.count
            
            for i in 0..<imageUrls.count {
                let imageUrlString = imageUrls[i]
                let imageUrl = URL(string: imageUrlString)
                let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))
                let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                imageView.backgroundColor = UIColor.init(colorType: .color_black)
                imageView.contentMode = .scaleAspectFit
                imageView.af_setImage(withURL: imageUrl!)
                
                imageView.cornerRadius = 15
                imageViews.append(imageView)
                self.mainImagesScrollView.addSubview(imageView)
            }
            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrls.count) * viewWidth), height: viewHeight)
        } else {
            
        }
    }
    
}

extension JobDetailDataCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            images.append(imageView.image!)
        }
        */
        
        let offsetX = scrollView.contentOffset.x
        
        if offsetX > (scrollView.frame.size.width * 1.5) {
            
            scrollSubViewChangeLast()
            
            scrollView.contentOffset.x -= self.mainImagesScrollView.bounds.size.width
            
            let subViews = scrollView.subviews
            for subView in subViews {
                Log.selectLog(logLevel: .debug, "subView:\(subView)")
            }
            
        }
        
        if offsetX < (scrollView.frame.size.width * 0.5) {
            
            scrollSubViewChangeFirst()
            /*
            let imageView = scrollView.subviews.first as! UIImageView
            let newImage = imageView.image
            images.removeLast()
            images.insert(newImage!, at: 0)
            
            layoutImages()
            scrollView.contentOffset.x += scrollView.contentSize.width
            */
            scrollView.contentOffset.x += self.mainImagesScrollView.bounds.size.width
        }
        
        
        let scrollViewPageCnt:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        mainImagesControl.currentPage = scrollViewPageCnt
    }
    
    private func scrollSubViewChangeLast() {
        Log.selectLog(logLevel: .debug, "scrollSubViewChangeLast start")
        
        for subView in self.mainImagesScrollView.subviews {
            if subView is UIImageView {
                subView.removeFromSuperview()
            }
        }
        
        for subView in self.mainImagesScrollView.subviews {
            Log.selectLog(logLevel: .debug, "subView:\(subView)")
        }
        
        /*
        let firstSubView = self.mainImagesScrollView.subviews.first
        Log.selectLog(logLevel: .debug, "firstSubView:\(String(describing: firstSubView))")
        
        if firstSubView is UIImageView {
            let addImageView = self.mainImagesScrollView.subviews.first as! UIImageView
            
            let i:Int = 0
            for subView in self.mainImagesScrollView.subviews {
                if i == 0 {
                    subView.removeFromSuperview()
                } else {
                    break
                }
            }
            
            for logSubView01 in self.mainImagesScrollView.subviews {
                Log.selectLog(logLevel: .debug, "logSubView01:\(String(describing: logSubView01))")
            }
            
            
            self.mainImagesScrollView.subviews.insert(addImageView, at: (imageCnt-1))
            
            for logSubView02 in self.mainImagesScrollView.subviews {
                Log.selectLog(logLevel: .debug, "logSubView02:\(String(describing: logSubView02))")
            }
            
            
            
        }
        */
        
        let contentWidth = self.mainImagesScrollView.bounds.size.width * CGFloat(imageCnt)
        let contentHeight = self.mainImagesScrollView.bounds.size.height
        self.mainImagesScrollView.contentSize = CGSize(width: contentWidth,
                                                       height: contentHeight)
    }
    
    private func scrollSubViewChangeFirst() {
        Log.selectLog(logLevel: .debug, "scrollSubViewChangeFirst start")
        var subViews = self.mainImagesScrollView.subviews
        for subView in subViews {
            Log.selectLog(logLevel: .debug, "subView:\(subView)")
        }
        
        let addImageView = subViews[(imageCnt-1)] as! UIImageView
        
        var i:Int = 0
        for subView in subViews {
            if i == (imageCnt-1) {
                subView.removeFromSuperview()
            } else {
                continue
            }
            i += 1
        }
        subViews.insert(addImageView, at: 0)
        
        let contentWidth = self.mainImagesScrollView.bounds.size.width * CGFloat(imageCnt)
        let contentHeight = self.mainImagesScrollView.bounds.size.height
        self.mainImagesScrollView.contentSize = CGSize(width: contentWidth,
                                                       height: contentHeight)
    }
}
