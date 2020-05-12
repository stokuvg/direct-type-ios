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
    @IBOutlet weak var jobCategoryLabel:UILabel!
    // 給与
    @IBOutlet weak var salaryBackView:UIView!
    @IBOutlet weak var salaryLabel:UILabel!
    @IBOutlet weak var salaryMarkLabel:UILabel!
    // 勤務地
    @IBOutlet weak var workPlaceBackView:UIView!
    @IBOutlet weak var workPlaceLabel:UILabel!
    // 社名
    @IBOutlet weak var companyBackView:UIView!
    @IBOutlet weak var companyLabel:UILabel!
    // 掲載期限
    @IBOutlet weak var limitBackView:UIView!
    @IBOutlet weak var limitLabel:UILabel!
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
        
        // 職種
        let job = data["job"] as! String
        self.jobCategoryLabel.text(text: job, fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 年収
        let salary = data["price"] as! String
        self.salaryLabel.text(text: salary, fontType: .C_font_XL, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
        self.salaryMarkLabel.text(text: "万円", fontType: .C_font_Sb ,textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        // 勤務地
        let area = data["area"] as! String
        self.workPlaceLabel.text(text: area, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 社名
        let company = data["company"] as! String
        self.companyLabel.text(text: company, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 期間
        let period_start_string:String = data["period_start"] as! String
        let period_end_string:String = data["period_end"] as! String
                
        let period_start = self.changeFormatString(string: period_start_string)
        let period_end = self.changeFormatString(string: period_end_string)
        
        let period_string = period_start + "〜" + period_end
        self.limitLabel.text(text: period_string, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
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
    
    private func changeFormatString(string:String) -> String {
        if string.count == 0 {
            return ""
        }
        
        let formatter:DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: string)
        
        let changeFormatter:DateFormatter = DateFormatter()
        changeFormatter.calendar = Calendar(identifier: .gregorian)
        changeFormatter.dateFormat = "yyyy年MM月dd日"
        
        return changeFormatter.string(from: date!)
        
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
