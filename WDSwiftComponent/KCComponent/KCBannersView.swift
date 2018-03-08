//
//  KCBannerView.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/28.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

/*
 KCBannerView = UIScrollView + UIPageControl
 */
open class KCBannersView : UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    open var bannerList : [UIImageView]? {
        willSet {
            self.bannerList?.forEach({ (view) in
                view.removeFromSuperview()
            })
        }
        didSet {
            weak var weakSelf = self
            self.bannerList?.forEach({ (view) in
                weakSelf?.scrollView.addSubview(view)
            })
            pageControl.numberOfPages = bannerList?.count ?? 0
            pageControl.currentPage = 0
            let size = pageControl.sizeForNumberOfPages(pageControl.numberOfPages)
            pageControl.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    open func getScrollView() -> UIScrollView {
        return self.scrollView
    }
    
    open let pageControl = KCPageControl()
    fileprivate var scrollView = UIScrollView()
    
    fileprivate func setUp() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 30))
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        weak var weakSelf = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        _=scrollView.rx.didEndDecelerating.takeUntil(self.rx.deallocating).subscribe(onNext: { (_) in
            if nil != weakSelf {
                let index = Int(weakSelf!.scrollView.contentOffset.x / weakSelf!.scrollView.bounds.width)
                if weakSelf!.pageControl.currentPage != index {
                    weakSelf?.pageControl.currentPage = index
                }
            }
        })
        pageControl.currentPageChanged = { [unowned self] (index) in
            let left = self.scrollView.width*CGFloat(index)
            if self.scrollView.contentOffset.x != left {
                self.scrollView.setContentOffset(CGPoint(x: left, y: 0), animated: true)
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        weak var weakSelf = self
        var left = CGFloat(0)
        let size = self.size
        self.bannerList?.forEach({ (view) in
            if nil != weakSelf {
                view.size = size
                view.left = left
                left += size.width
            }
        })
        
        if let count = self.bannerList?.count {
            self.scrollView.contentSize = CGSize(width: self.scrollView.size.width*CGFloat(count), height: self.scrollView.size.height)
        }
    }    
}
