//
//  IconCarouselView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class IconCarouselView: UICollectionView {
    
    private var contents = [UIView]()
    private var contentItemSize = CGSize.zero
    private var carouselTimer: Timer?
    // FIXME: デバッグ用なので後から削除
    private let colors: [UIColor] = [.blue, .yellow, .red, .green, .gray]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    func configure(with contents: [UIView]) {
        self.contents = contents
        contentItemSize = contents.first!.frame.size
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
        return 1000
    }
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        // FIXME: デバッグ用なので後から削除
        contentItemSize = CGSize(width: 100, height: 100)
        layout.itemSize = contentItemSize
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.id)
        // FIXME: デバッグ用なので後から削除
        inputDummyData()
    }
    
    @objc
    func sctollToNext() {
        UIView.animate(withDuration: 0, delay: 0, animations: { [weak self] in
            guard let `self` = self else { return }
            self.contentOffset.x += 0.3
        })
    }
    
    // FIXME: デバッグ用なので後から削除
    func inputDummyData() {
        for _ in 0..<colors.count {
            let contentView = UIView()
            contents.append(contentView)
        }
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
        let colorIndex = indexPath.row % contents.count
        cell.backgroundColor = colors[colorIndex]
        return cell
    }
}
