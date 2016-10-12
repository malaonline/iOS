//
//  Extension+UIImageView.swift
//  mala-ios
//
//  Created by Elors on 1/7/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    ///  Convenience to Create a UIImageView that prepare to display image
    ///
    ///  - returns: UIImageView
    class func placeHolder() -> UIImageView {
        let placeHolder = UIImageView()
        placeHolder.contentMode = .scaleAspectFill
        placeHolder.clipsToBounds = true
        return placeHolder
    }
    
    
    func ma_setImage(_ URL: URL? = nil, placeholderImage: Image? = nil, progressBlock: DownloadProgressBlock? = nil, completionHandler: CompletionHandler? = nil) {
        
        // 使用图片绝对路径作为缓存键值
        guard let URL = URL else {
            return
        }
        let splitArray = URL.absoluteString.components(separatedBy: "?")
        guard let pureURL = splitArray.first, !pureURL.isEmpty else {
            return
        }
        
        // 加载图片资源
        let resource = ImageResource(downloadURL: URL, cacheKey: pureURL)
        
        self.kf.setImage(
            with: resource,
            placeholder: placeholderImage,
            options: [.transition(.fade(0.25)), .targetCache(ImageCache(name: pureURL))],
            progressBlock: progressBlock,
            completionHandler: completionHandler
        )
    }
}
