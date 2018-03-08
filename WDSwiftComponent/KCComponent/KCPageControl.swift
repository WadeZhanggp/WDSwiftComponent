//
//  KCPageControl.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/12/7.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation


/*
 为什么重写UIPageControl？
    iOS的UIPageControl在涉及到复杂的自动布局的时候出现所有的点重叠起来，显示在左上角
 */
open class KCPageControl : UIControl {
    fileprivate var points = [UIView]()
    
    var currentPageChanged : (Int)->() = {_ in
    }
    
    public var numberOfPages : Int = 0 {
        didSet {
            _=self.tap
            if numberOfPages > points.count {
                for _ in 0..<(numberOfPages-points.count) {
                    let view = pointViewGeneration()
                    self.points.append(view)
                    self.addSubview(view)
                }
            } else if numberOfPages < points.count {
                for _ in 0..<points.count-numberOfPages {
                    let view = self.points.removeLast()
                    view.removeFromSuperview()
                }
            }
            self.isHidden = numberOfPages <= 1 && hidesForSinglePage
            updatePoints()
        }
    }
    public var currentPage : Int = 0 {
        didSet {
            updatePoints()
            currentPageChanged(currentPage)
        }
    }
    public var pageIndicatorTintColor : UIColor = UIColor.lightGray {
        didSet {
            updatePoints()
        }
    }
    public var currentPageIndicatorTintColor : UIColor = UIColor.white {
        didSet {
            updatePoints()
        }
    }    
    public var hidesForSinglePage : Bool = true {
        didSet {
            self.isHidden = numberOfPages <= 1 && hidesForSinglePage
        }
    }
    public var pointViewGeneration : ()->UIView = {
        let view = UIView()
        view.updateWithConfigData(["layer.masksToBounds":true])
        return view
    }
    var pointSize : CGSize = CGSize(width: 6, height: 6) {
        didSet {
            updatePoints()
        }
    }
    var pointDistance : CGFloat = 20 {
        didSet {
            updatePoints()
        }
    }
    
    fileprivate var _tap : UITapGestureRecognizer?
    fileprivate var tap : UITapGestureRecognizer {
        get {
            if let tap = _tap {
                return tap
            }
            let tap = UITapGestureRecognizer(target: nil, action: nil)
            self.addGestureRecognizer(tap)
            
            _=tap.rx.event.subscribe(onNext: { (gesture) in
                let touchLocation = gesture.location(in: self)
                if self.points.count > 0
                    && self.currentPage >= 0
                    && self.currentPage < self.points.count {
                    
                    let currentPoint = self.points[self.currentPage]
                    if touchLocation.x < currentPoint.left + currentPoint.width/2 - self.pointDistance/2 {
                        let page = self.currentPage - 1
                        if page >= 0 {
                            self.currentPage = page
                        }
                    } else if touchLocation.x > currentPoint.left + currentPoint.width/2 + self.pointDistance/2 {
                        let page = self.currentPage + 1
                        if page < self.numberOfPages {
                            self.currentPage = page
                        }
                    }
                }
            })
            return tap
        }
    }
    
    public func sizeForNumberOfPages(_ pageCount: Int) -> CGSize {
        let width = self.pointDistance*CGFloat(pageCount)+self.pointSize.width+4
        let height = self.pointSize.height + 4
        return CGSize(width: width, height: height)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
    }
    
    fileprivate func updatePoints() {
        if self.superview != nil && numberOfPages > 0 {
            let size = self.pointSize
            var pointCenterX = (self.width - self.pointDistance*CGFloat(numberOfPages-1))/2
            for i in 0..<self.points.count {
                let point = self.points[i]
                point.layer.cornerRadius = size.height/2
                point.backgroundColor = i == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor
                point.size = size
                point.centerX = pointCenterX
                point.centerY = self.height/2
                pointCenterX += self.pointDistance
            }
        }
    }
}
