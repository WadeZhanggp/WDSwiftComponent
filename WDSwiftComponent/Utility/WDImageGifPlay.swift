//
//  WDImageGifPlay.swift
//  WDSwiftComponent
//
//  Created by zhangguangpeng on 2017/11/7.
//  Copyright © 2017年 zhangguangpeng. All rights reserved.
//

import UIKit

class AUImageGifPlay: NSObject {
    
    class func showGif(gifView: UIImageView , gifImageName: String) {
        guard let path = Bundle.main.path(forResource: gifImageName, ofType: "gif"),
            let data = NSData(contentsOfFile: path),
            let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            i == 0 ? gifView.image = image : ()
            images.append(image)
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary,
                let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary,
                let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        gifView.animationImages = images
        gifView.animationDuration = totalDuration
        gifView.animationRepeatCount = 0
        gifView.startAnimating()
    }
    
}
