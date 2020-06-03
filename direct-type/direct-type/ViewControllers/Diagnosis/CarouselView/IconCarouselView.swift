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
    // FIXME: デバッグ用なので後から削除
    private let colors: [UIColor] = [.blue, .yellow, .red, .green, .gray]
    
    func configure(with contents: [UIView]) {
        self.contents = contents
        contentItemSize = contents.first!.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
}

private extension IconCarouselView {
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
        let contentWidth = floor(scrollView.contentSize.width / CGFloat(bulkingValueForCellCount))
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > contentWidth * 2.0) {
            scrollView.contentOffset.x = contentWidth
        }
    }
}

extension IconCarouselView: UICollectionViewDataSource {
    private var bulkingValueForCellCount: Int {
        return 3
    }
    
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
