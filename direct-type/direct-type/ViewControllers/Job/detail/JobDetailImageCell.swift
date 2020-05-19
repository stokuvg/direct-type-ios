//
//  JobDetailImageCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/19.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

class JobDetailImageCell: BaseTableViewCell {
    
    // メイン画像
    @IBOutlet weak var mainImageBackView:UIView!
    var mainImagesScrollView:UIScrollView!
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
    
    var imageCnt:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func setCellWidth(width:CGFloat) {
        Log.selectLog(logLevel: .debug, "JobDetailDataCell setCellWidth start")
        
        var mainImageBackFrame = self.mainImageBackView.frame
        mainImageBackFrame.size.width = self.contentView.frame.size.width
        self.mainImageBackView.frame = mainImageBackFrame
        
        cellWidth = width
        
        viewWidth = self.mainImageBackView.frame.size.width
        viewHeight = self.mainImageBackView.frame.size.height
        
        // 表示画像用
        imageH = viewHeight                     // 画像高さ 比率 11:8
        imageW = (imageH * 11 / 8) - (margin * 2)
        
        imageY = 0        // 画像表示位置 Y
        
        imageX = (viewWidth - imageW) / 2                         // 画像表示位置 X
        
        margin = imageX
        
        self.mainImagesScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        self.mainImagesScrollView.isPagingEnabled = true
        self.mainImagesScrollView.delegate = self
        self.mainImageBackView.addSubview(self.mainImagesScrollView)
    }
    
    func setup(data:[String:Any]) {
        // 画像セット
        let imageUrls:[String] = data["images"] as! [String]
        imageCnt = imageUrls.count
        if imageUrls.count > 1 {
            
            self.mainImagesControl.numberOfPages = imageUrls.count
            
            for i in 0..<(imageUrls.count * 3) {
                var cnt:Int = 0
                cnt = i
                if i >= imageUrls.count {
                    cnt = i % imageUrls.count
                }
                let imageUrlString = imageUrls[cnt]
                let imageUrl = URL(string: imageUrlString)
                let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))

                let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                imageView.backgroundColor = UIColor.init(colorType: .color_black)
                imageView.contentMode = .scaleAspectFit
                imageView.af_setImage(withURL: imageUrl!)
                
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                imageView.clipsToBounds = true
                
                self.mainImagesScrollView.addSubview(imageView)
            }
            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrls.count*3) * viewWidth), height: viewHeight)
            
        } else {
            
        }
    }
    
}

extension JobDetailImageCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Log.selectLog(logLevel: .debug, "JobDetailDataCell scrollViewDidScroll start")
        
        let pageWidth = scrollView.contentSize.width / 3.0
        
        if scrollView.contentOffset.x <= 0.0 || (scrollView.contentOffset.x > pageWidth * 2.0) {
            scrollView.contentOffset.x = pageWidth
        }
        
        let pageOffsetX = Int(scrollView.contentOffset.x)
        
        let scrollWidth = Int(scrollView.bounds.size.width)
        
        let pageNo = pageOffsetX / scrollWidth
        let changePageNo = pageNo % imageCnt
        
        self.mainImagesControl.currentPage = changePageNo
    }
    
}
