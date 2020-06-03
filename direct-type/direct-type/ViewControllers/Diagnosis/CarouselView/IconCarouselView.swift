//
//  IconCarouselView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class IconCarouselView: UICollectionView {
    
    private var contents = [UIImageView]()
    private var carouselTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    func configure(with contents: [UIImageView]) {
        self.contents = contents
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = contents.first!.frame.size
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
    }
    
    func startAnimation() {
        carouselTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                             selector: #selector(self.sctollToNext),
                                             userInfo: nil, repeats: true)
    }
    
    deinit {
        carouselTimer?.invalidate()
    }
}

private extension IconCarouselView {
    var contentOffsetResetThreshold: CGFloat {
        return CGFloat(bulkingValueForCellCount / contents.count)
    }
    
    var contentWidth: CGFloat {
        return floor(contentSize.width / CGFloat(bulkingValueForCellCount))
    }
    
    var currentDisplayCellIndex: Int {
        guard contentWidth != CGFloat.zero else { return Int.zero }
        return Int(contentOffset.x) % Int(contentWidth)
    }
    
    var bulkingValueForCellCount: Int {
        // このかさ増しの閾値を超えるとcontentOffsetとIndexがリセットされる
        return 100
    }
    
    func setup() {
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.id)
    }
    
    @objc
    func sctollToNext() {
        UIView.animate(withDuration: 0, delay: 0, animations: { [weak self] in
            guard let `self` = self else { return }
            self.contentOffset.x += 0.3
        })
    }
}

extension IconCarouselView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x <= CGFloat.zero) || (scrollView.contentOffset.x > contentWidth * contentOffsetResetThreshold) {
            scrollView.contentOffset.x = contentWidth
        }
    }
}

extension IconCarouselView: UICollectionViewDataSource {
    private var cellCountForInfinityScroll: Int {
        return contents.count * bulkingValueForCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCountForInfinityScroll
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CarouselCell.id, for: indexPath)
        let fixedIndex = indexPath.row % contents.count
        cell.addSubview(contents[fixedIndex])
        return cell
    }
}
