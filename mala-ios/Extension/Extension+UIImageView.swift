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
    
    convenience init(imageName name: String) {
        self.init()
        self.image = UIImage(named: name)
    }
    
    convenience init(frame: CGRect? = nil, cornerRadius: CGFloat? = nil, image: String? = nil, contentMode: UIViewContentMode = .scaleAspectFill) {
        self.init()
        
        if let frame = frame {
            self.frame = frame
        }
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
        
        if let imageName = image {
            self.image = UIImage(named: imageName)
        }
        
        self.contentMode = contentMode
    }
    
    func setImage(withImageName name: String?) {
        image = UIImage(named: name ?? "")
    }
    
    func setImage(withURL url: String? = nil, placeholderImage: String? = "profileAvatar_placeholder", progressBlock: DownloadProgressBlock? = nil, completionHandler: CompletionHandler? = nil) {
        
        // 使用图片绝对路径作为缓存键值
        guard let url = url, let URL = URL(string: url) else {
            println(#function)
            return
        }
        let splitArray = URL.absoluteString.components(separatedBy: "?")
        guard let pureURL = splitArray.first, !pureURL.isEmpty else {
            return
        }
        
        // 加载图片资源
        let resource = ImageResource(downloadURL: URL, cacheKey: pureURL)
        
        if let placeholderImage = placeholderImage, let placeholder = Image(named: placeholderImage) {
            self.kf.setImage(
                with: resource,
                placeholder: placeholder,
                options: [.transition(.fade(0.25)), .targetCache(ImageCache(name: pureURL))],
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        }else {
            self.kf.setImage(
                with: resource,
                options: [.transition(.fade(0.25)), .targetCache(ImageCache(name: pureURL))],
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        }
    }
}
