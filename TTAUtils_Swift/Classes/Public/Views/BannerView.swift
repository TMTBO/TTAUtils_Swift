//
//  BannerView.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 07/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import FSPagerView

let kBANNER_VIEW_CELL_IDENTIFIER = "bannerViewCellIdentifier"

@objc
protocol BannerViewDelegate: NSObjectProtocol {
    @objc
    func bannerView(bannerView: BannerView, didSelectItemAt Index: Int)
    
}

class BannerView: UIView {
    
    var models: [BannerModel]? = [] {
        didSet {
            configureBannerView()
            pagerView.reloadData()
        }
    }
    
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: self.frame)
        pagerView.automaticSlidingInterval = 5.0
        pagerView.isInfinite = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: kBANNER_VIEW_CELL_IDENTIFIER)
        self.addSubview(pagerView)
        return pagerView
    }()
    
    lazy var pageControl: FSPageControl = {
        let pageControlHeight: CGFloat = 25.0
        let pageControl = FSPageControl(frame: CGRect(x: 0, y: self.frame.size.height - pageControlHeight, width: self.frame.size.width, height: pageControlHeight))
        pageControl.contentHorizontalAlignment = .right
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.setStrokeColor(UIColor.red, for: UIControlState.normal)
        pageControl.setFillColor(UIColor.white, for: .selected)
        self.addSubview(pageControl)
        return pageControl
    }()
    
    weak var delegate: BannerViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, delegate: BannerViewDelegate?, models: [BannerModel]? = nil) {
        super.init(frame: frame)
        self.models = models
        self.delegate = delegate
        configureBannerView()
    }

}

extension BannerView {
    
    fileprivate func configureBannerView() {
        if models == nil {
            pagerView.automaticSlidingInterval = 0.0
            pagerView.isInfinite = false
            pageControl.isHidden = true
            pageControl.numberOfPages = 1
        } else {
            pagerView.automaticSlidingInterval = 5.0
            pagerView.isInfinite = true
            pagerView.reloadData()
            pageControl.isHidden = false
            if let count = self.models?.count {
                pageControl.numberOfPages = count
            }
        }
    }
    
}

// MARK: - FSPagerViewDataSource

extension BannerView: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let newModels = models else { return 1 }
        return newModels.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: kBANNER_VIEW_CELL_IDENTIFIER, at: index)
        let url = URL(string: models?[index].image ?? "")
        cell.imageView?.tta.setImage(with: url, placeholder: UIImage(named: ""))
//        cell.textLabel?.text = models?[index].title
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension BannerView: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        pageControl.currentPage = index
        if let _ = delegate?.responds(to: #selector(BannerViewDelegate.bannerView(bannerView:didSelectItemAt:))) {
            delegate?.bannerView(bannerView: self, didSelectItemAt: index)
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        var currentIndex = pagerView.currentIndex
        if currentIndex == models?.count {
            currentIndex = 0
        }
        self.pageControl.currentPage = currentIndex
    }
    
}
