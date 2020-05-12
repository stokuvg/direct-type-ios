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
    
    
    var imageList:[String] = []
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
                imageView.tag = (i+1)
                imageView.cornerRadius = 15
                imageList.append(imageUrlString)
                self.mainImagesScrollView.addSubview(imageView)
            }
            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrls.count) * viewWidth), height: viewHeight)
        } else {
            
        }
    }
    
    func setupImageViews() {
        if imageList.count > 0 {
            for i in 0..<self.imageList.count {
                let imageUrlString = imageList[i]
                let imageUrl = URL(string: imageUrlString)
                let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))
                let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                imageView.backgroundColor = UIColor.init(colorType: .color_black)
                imageView.contentMode = .scaleAspectFit
                imageView.af_setImage(withURL: imageUrl!)
                imageView.tag = (i+1)
                imageView.cornerRadius = 15
                self.mainImagesScrollView.addSubview(imageView)
            }
            
        }
    }
    
    private func updatePageControl(scrollView:UIScrollView) {
        Log.selectLog(logLevel: .debug, "JobDetailDataCell updatePageControl start")
        
        let pageWidth = scrollView.frame.size.width
        Log.selectLog(logLevel: .debug, "pageWidth:\(pageWidth)")
        let pageOffsetX = scrollView.contentOffset.x
        Log.selectLog(logLevel: .debug, "pageOffsetX:\(pageOffsetX)")
        let pageNo = Int(pageOffsetX / pageWidth)
        Log.selectLog(logLevel: .debug, "pageNo:\(pageNo)")
        self.mainImagesControl.currentPage = pageNo
        
        let checkPageNo = Int(pageOffsetX / pageWidth / 1.5)
        Log.selectLog(logLevel: .debug, "checkPageNo:\(checkPageNo)")
    }
    
}

extension JobDetailDataCell: UIScrollViewDelegate {
    
    /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        Log.selectLog(logLevel: .debug, "JobDetailDataCell scrollViewWillEndDragging start")
        
        Log.selectLog(logLevel: .debug, "scrollView:\(scrollView)")
    }
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Log.selectLog(logLevel: .debug, "JobDetailDataCell scrollViewDidScroll start")
        
        let offsetX = self.mainImagesScrollView.contentOffset.x
//        Log.selectLog(logLevel: .debug, "offsetX:\(offsetX)")
        
        if offsetX > (self.mainImagesScrollView.frame.size.width * 1.5) {
            // 画像の要素を末尾の要素にする
            let sortedImage = self.imageList[0]
            self.imageList.append(sortedImage)
            // 画像の一覧の先頭要素を削除
            self.imageList.removeFirst()
            // 順番が入れ替えられたimageListで描画
            self.setupImageViews()
            
            // ページコントロールを更新
            self.updatePageControl(scrollView: scrollView)
            
//            self.mainImagesScrollView.contentOffset.x -= self.mainImagesScrollView.frame.size.width
            self.mainImagesScrollView.contentOffset.x -= cellWidth
            
        }
        
        if offsetX < (self.mainImagesScrollView.frame.size.width * 0.5) {
            // 画像の末尾要素を先頭の要素にする
            let sortedImage = self.imageList.last
            self.imageList.insert(sortedImage!, at: 0)
            // 画像の一覧の末尾要素を削除
            self.imageList.removeLast()
            // 順番が入れ替えられたimageListで描画
            self.setupImageViews()
            // ページコントロールを更新
            self.updatePageControl(scrollView: scrollView)
            
//            self.mainImagesScrollView.contentOffset.x += self.mainImagesScrollView.bounds.size.width
            self.mainImagesScrollView.contentOffset.x += cellWidth
            
        }
        
    }
    
}
