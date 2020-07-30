//
//  JobDetailImageCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/19.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageBackView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class JobDetailImageCell: BaseTableViewCell {
    
    // メイン画像
    @IBOutlet weak var mainImageBackView:UIView!
    var mainImagesScrollView:UIScrollView!
    // 画像複数
    @IBOutlet weak var mainImagesPageControlBackView:UIView!
    @IBOutlet weak var mainImagesControl:UIPageControl!
    
    @IBOutlet weak var pageControlViewHeight:NSLayoutConstraint!
    
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
//        Log.selectLog(logLevel: .debug, "JobDetailImageCell awakeFromNib start")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    func setCellWidth(width:CGFloat) {
//        Log.selectLog(logLevel: .debug, "JobDetailImageCell setCellWidth start")
        var mainImageBackFrame = self.mainImageBackView.frame
//        mainImageBackFrame.size.width = self.contentView.frame.size.width
        mainImageBackFrame.size.width = width
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
        
        if addImageScrollViewCheck() {
            Log.selectLog(logLevel: .debug, "スクロール初回のみadd")
            self.mainImagesScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
            self.mainImagesScrollView.isPagingEnabled = true
            self.mainImagesScrollView.showsVerticalScrollIndicator = false
            self.mainImagesScrollView.showsHorizontalScrollIndicator = false
            self.mainImagesScrollView.delegate = self
            
            self.mainImageBackView.addSubview(self.mainImagesScrollView)
        }
    }
    
    private func addImageScrollViewCheck() -> Bool {
//        Log.selectLog(logLevel: .debug, "JobDetailImageCell addImageScrollViewCheck start")
        var addFlag:Bool = true
        for _subView in self.mainImageBackView.subviews {
//            Log.selectLog(logLevel: .debug, "_subView:\(_subView)")
            if _subView is UIScrollView {
                addFlag = false
                break
            }
        }
        return addFlag
    }
    private func addImageScrollCheck() -> Bool {
//        Log.selectLog(logLevel: .debug, "JobDetailImageCell addImageScrollCheck start")
        var addFlag:Bool = true
        for _subView in self.mainImagesScrollView.subviews {
//            Log.selectLog(logLevel: .debug, "_subView:\(_subView)")
            if _subView is ImageBackView {
//            if _subView is UIImageView {
                addFlag = false
                break
            }
        }
        return addFlag
    }
    
    private func makeBackViewSize(viewSize:CGSize,imageSize: CGSize) -> CGSize {
        
        var backViewWidth:CGFloat = 0.0
        var backViewHeight:CGFloat = 0.0
        
        backViewWidth = viewSize.width - (margin * 2)
        backViewHeight = (backViewWidth*imageSize.height)/imageSize.width
        if backViewHeight > viewSize.height {
            backViewHeight = viewSize.height
        }
        
        let backViewSize = CGSize(width: backViewWidth, height: backViewHeight)
        return backViewSize
    }
    
    func setup(data: MdlJobCardDetail) {
//        Log.selectLog(logLevel: .debug, "JobDetailImageCell setup start")
        // 画像セット
        
        let mainImageUrlString:String = data.mainPicture
        let subImageUrlStrings:[String] = data.subPictures
        
        let imageSizeCheckView:UIImageView! = UIImageView()
        let checkImageURL = URL(string: mainImageUrlString)
        imageSizeCheckView.af_setImage(withURL: checkImageURL!)
        let checkImage = imageSizeCheckView.image
//        Log.selectLog(logLevel: .debug, "checkImage:\(String(describing: checkImage))")
        let checkImageSize = checkImage?.size ?? CGSize.zero
//        Log.selectLog(logLevel: .debug, "checkImageSize:\(String(describing: checkImageSize))")
        
        let backViewSize = self.makeBackViewSize(viewSize: self.mainImagesScrollView.bounds.size, imageSize: checkImageSize)
        
        imageY = (viewHeight - backViewSize.height) / 2
        
        var imageUrlStrings:[String] = [mainImageUrlString]
        if subImageUrlStrings.count > 0 {
            for i in 0..<subImageUrlStrings.count {
                let _subImageUrlString = subImageUrlStrings[i]
                if _subImageUrlString.count > 0 {
                    imageUrlStrings.append(_subImageUrlString)
                }
            }
        }
        
        imageCnt = imageUrlStrings.count
        if imageCnt > 1 {
            
            self.mainImagesControl.numberOfPages = imageUrlStrings.count
            
            if addImageScrollCheck() {
                // 無限スクロール用
                for i in 0..<(imageUrlStrings.count * 3) {
                    var cnt:Int = 0
                    cnt = i
                    if i >= imageUrlStrings.count {
                        cnt = i % imageUrlStrings.count
                    }
                    
                    let imageUrlString = imageUrlStrings[cnt]
                    let imageUrl = URL(string: imageUrlString)
                    let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))
                    
                    let imageBackView = ImageBackView.init(frame: CGRect(x: scrollX, y: imageY, width: backViewSize.width, height: backViewSize.height))
                    
                    imageBackView.layer.cornerRadius = 15
                    imageBackView.layer.masksToBounds = true
                    imageBackView.clipsToBounds = true

//                    let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                    let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: backViewSize.width, height: backViewSize.height))
                    imageView.backgroundColor = UIColor.init(colorType: .color_white)
                    imageView.contentMode = .scaleAspectFit
                    imageView.af_setImage(withURL: imageUrl!)
                    
                    imageView.layer.cornerRadius = 15
                    imageView.layer.masksToBounds = true
                    imageView.clipsToBounds = true
                    
                    imageBackView.addSubview(imageView)
                    
                    self.mainImagesScrollView.addSubview(imageBackView)
                }
                self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrlStrings.count*3) * viewWidth), height: viewHeight)
            }
            
        } else {
            for i in 0..<(imageUrlStrings.count) {
                var cnt:Int = 0
                cnt = i
                if i >= imageUrlStrings.count {
                    cnt = i % imageUrlStrings.count
                }
                let imageUrlString = imageUrlStrings[cnt]
                if addImageScrollCheck() {
                    if imageUrlString.count > 0 {
                        let imageUrl = URL(string: imageUrlString)
                        let scrollX:CGFloat = (margin + (viewWidth * CGFloat(i)))

                        let imageBackView = ImageBackView.init(frame: CGRect(x: scrollX, y: imageY, width: backViewSize.width, height: backViewSize.height))
//                        let imageBackView = UIView.init(frame: CGRect(x: scrollX, y: imageY, width: backViewSize.width, height: backViewSize.height))
                        
                        imageBackView.layer.cornerRadius = 15
                        imageBackView.layer.masksToBounds = true
                        imageBackView.clipsToBounds = true

                        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: backViewSize.width, height: backViewSize.height))
//                        let imageView = UIImageView.init(frame: CGRect(x: scrollX, y: imageY, width: imageW, height: imageH))
                        imageView.backgroundColor = UIColor.init(colorType: .color_white)
                        imageView.contentMode = .scaleAspectFit
                        imageView.af_setImage(withURL: imageUrl!)
                        
                        imageView.layer.cornerRadius = 15
                        imageView.layer.masksToBounds = true
                        imageView.clipsToBounds = true
                        
                        imageBackView.addSubview(imageView)
                        
                        self.mainImagesScrollView.addSubview(imageBackView)
                    }
                }
            }
            self.mainImagesScrollView.contentSize = CGSize(width: (CGFloat(imageUrlStrings.count) * viewWidth), height: viewHeight)
            
            self.mainImagesControl.numberOfPages = 1
            self.mainImagesControl.isHidden = true
            self.pageControlViewHeight.constant = 40
            self.mainImagesPageControlBackView.isHidden = true
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
