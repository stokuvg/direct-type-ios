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
        imageCnt = imageUrls.count
        if imageUrls.count > 1 {
            
            self.mainImagesControl.numberOfPages = imageUrls.count
            
            for i in 0..<(imageUrls.count * 3) {
//            for i in 0..<imageUrls.count {
                var cnt:Int = 0
                cnt = i
                if i >= imageUrls.count {
                    cnt = i % imageUrls.count
                }
                let imageUrlString = imageUrls[cnt]
//                let imageUrlString = imageUrls[i]
                let imageUrl = URL(string: imageUrlString)
                let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))
                let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                imageView.backgroundColor = UIColor.init(colorType: .color_black)
                imageView.contentMode = .scaleAspectFit
                imageView.af_setImage(withURL: imageUrl!)
                imageView.cornerRadius = 15
                
                self.mainImagesScrollView.addSubview(imageView)
            }
//            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrls.count) * viewWidth), height: viewHeight)
            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrls.count*3) * viewWidth), height: viewHeight)
        } else {
            
        }
    }
    
}

extension JobDetailDataCell: UIScrollViewDelegate {
    
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
