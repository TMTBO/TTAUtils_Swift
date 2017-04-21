//
//  TTABannerView.swift
//  TTAUtils_Swift
//
//  Created by TobyoTenma on 06/04/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

protocol TTABannerViewDelegate: class {
    
    func bannerView(_ bannerView: TTABannerView, didSelectItemAt index: Int)
    
    func bannerView(_ bannerView: TTABannerView, didScrollTo index: Int)
}
extension TTABannerViewDelegate {
    
    func bannerView(_ bannerView: TTABannerView, didSelectItemAt index: Int) {
        
    }
    func bannerView(_ bannerView: TTABannerView, didScrollTo index: Int) {
        
    }
}

class TTABannerView: UIView {
    
    struct TTABannerViewConst {
        static let collectionViewCellIdentifier = "collectionViewCellIdentifier"
        static let pageControlHeight: CGFloat = 30
        
        static let countMultiple = 100000
    }
    
    // MARK: - Public Properties
    /// 图片 URL 数组
    open var imageURLStrings: [String] = [] {
        willSet {
            images = newValue
        }
    }
    /// 本地图片名数组
    open var imageNames: [String] = [] {
        willSet {
            images = newValue
        }
    }
    /// 没有图片获取到图片时,占位图
    open var placeholderImage: UIImage? {
        willSet {
            backGroundImageView.isHidden = false
            backGroundImageView.image = newValue
        }
    }
    open weak var delegate: TTABannerViewDelegate?
    /// 滚动时间间隔
    open var autoScrollTimeInterval: TimeInterval = 2
    /// 是否循环滚动
    open var isRepeat = true
    /// 是否自动滚动
    open var isAutoScroll = true {
        didSet {
            if isAutoScroll {
                addTimer()
            }
        }
    }
    /// 是否显示 pageControl
    open var isShowPageControl = true {
        willSet {
            pageControl.isHidden = !newValue
        }
    }
    /// pageControl 背景颜色
    open var pageControlBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.5) {
        willSet {
            pageControl.backgroundColor = pageControlBackgroundColor
        }
    }
    /// pageControl 当前点的颜色
    open var currentPageIndicatorTintColor: UIColor = .white {
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    /// pageControl 当其它点的颜色
    open var pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5) {
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    
    // MARK: - Private Properties
    fileprivate let layout = UICollectionViewFlowLayout()
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let pageControl = UIPageControl()
    fileprivate let backGroundImageView = UIImageView()
    fileprivate var timer: Timer?
    fileprivate var totalItemCount = 0
    /// collectionView数据源
    fileprivate var images: [String] = [] {
        willSet {
            let imageCount = newValue.count
            guard imageCount != 0 else { return }
            totalItemCount = imageCount * TTABannerViewConst.countMultiple
            pageControl.numberOfPages = imageCount
            collectionView.reloadData()
            backGroundImageView.isHidden = !(imageCount == 0)
            pageControl.isHidden = !isShowPageControl
            if isAutoScroll {
                addTimer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    deinit {
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
}

// MARK: - Public Method

extension TTABannerView {
    
    convenience init(_ frame: CGRect, imageNames: [String], isRepeat: Bool) {
        self.init(frame: frame)
        self.isRepeat = isRepeat
    }
    
    convenience init(_ frame: CGRect, imageURLStrings: [String], delegate: TTABannerViewDelegate?) {
        self.init(frame: frame)
        self.imageURLStrings = imageURLStrings
        self.delegate = delegate
    }
    
    convenience init(_ frame: CGRect, placeholderImage: UIImage?, delegate: TTABannerViewDelegate?) {
        self.init(frame: frame)
        self.delegate = delegate
        self.placeholderImage = placeholderImage
        backGroundImageView.image = placeholderImage
    }
    
    static func clearMemoryCache() {
        TTAUtilsManager.shared.clearMemoryCache()
    }
    static func clearDiskCache() {
        TTAUtilsManager.shared.clearDiskCache()
    }
    static func clearDiskCache(completion: @escaping () -> ()) {
        TTAUtilsManager.shared.clearDiskCache(completion: completion)
    } 
}

// MARK: - LifeCycle

extension TTABannerView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutViews()
        layout.itemSize = bounds.size
        if collectionView.contentOffset.x == 0 && totalItemCount != 0 {
            let targetIndex = isRepeat ? totalItemCount / 2 : 0
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil, images.count > 0 {
            addTimer()
        } else {
            removeTimer()
        }
    }
    
}

// MARK: - UI

fileprivate extension TTABannerView {
    
    func setupUI() {
        _addViews()
        _prepareLayout()
        _configViews()
        _layoutViews()
    }
    
    func _addViews() {
        addSubview(collectionView)
        addSubview(pageControl)
        insertSubview(backGroundImageView, belowSubview: collectionView)
    }
    
    func _configViews() {
        backgroundColor = .lightGray
        collectionView.backgroundColor = .clear
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TTABannerViewCell.self, forCellWithReuseIdentifier: TTABannerViewConst.collectionViewCellIdentifier)
        
        pageControl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        pageControl.isHidden = true
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        pageControl.numberOfPages = totalItemCount
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
    }
    
    func _layoutViews() {
        collectionView.frame = bounds
        pageControl.frame = CGRect(x: 0, y: bounds.size.height - TTABannerViewConst.pageControlHeight, width: bounds.size.width, height: TTABannerViewConst.pageControlHeight)
        backGroundImageView.frame = bounds
    }
    
    func _prepareLayout() {
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = bounds.size == .zero ? CGSize(width: 375, height: 170) : bounds.size
    }
}

// MARK: - Private Method

fileprivate extension TTABannerView {
    
    func currentIndex() -> Int {
        if collectionView.bounds.width == 0 {
            return 0
        }
        let offsetX = collectionView.contentOffset.x
        let itemWidth = bounds.size.width
        let index = (offsetX + itemWidth * 0.5) / itemWidth
        return Int(index)
    }
}

// MARK: - Timer

fileprivate extension TTABannerView {
    
    func addTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScrollToNext), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func removeTimer() {
        guard let atimer = timer else { return }
        atimer.invalidate()
        timer = nil
    }
    
    @objc func autoScrollToNext() {
        let index = currentIndex()
        var targetIndex = index + 1
        var isAnimated = true
        if targetIndex >= totalItemCount {
            if isRepeat {
                targetIndex = totalItemCount % 2 == 0 ? totalItemCount / 2 : totalItemCount / 2 - 1
                isAnimated = false
            }
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: isAnimated)
    }
}

// MARK: - UICollectionViewDataSource

extension TTABannerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TTABannerViewConst.collectionViewCellIdentifier, for: indexPath) as! TTABannerViewCell
        let imageString = images[indexPath.row % images.count]
        if imageString.hasPrefix("http") {
            let url = URL(string: imageString)
            cell.imageView.tta.setImage(with: url, placeholder: placeholderImage)
        } else{
            cell.imageView.image = UIImage(named: imageString)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TTABannerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.bannerView(self, didSelectItemAt: indexPath.item % images.count)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = currentIndex()
        if index == 0 {
            index = totalItemCount
        } else if index == totalItemCount - 1 {
            index = totalItemCount - 1
        }
        pageControl.currentPage = index % images.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll {
            removeTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        var index = currentIndex()
        if index == 0 {
            index = totalItemCount
        } else if index == totalItemCount - 1 {
            index = totalItemCount - 1
        }
        scrollView.contentOffset = CGPoint(x: CGFloat(index) * bounds.size.width, y: 0)
        let pageControlCurrentIndex = index % images.count
        pageControl.currentPage = pageControlCurrentIndex
        
        delegate?.bannerView(self, didScrollTo: pageControlCurrentIndex)
    }
    
}
