//
//  Extension+UIImageView.swift
//  mala-ios
//
//  Created by Elors on 1/7/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - Class Method
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
}

// MARK: - Convenience
extension UIImageView {
    
    /// Convenience to Create a UIImageView whit a image name
    ///
    /// - Parameter name: String of image resource name
    convenience init(imageName name: String) {
        self.init()
        self.image = UIImage(named: name)
    }
    
    /// Convenience to Create a UIImageView that
    ///
    /// - Parameters:
    ///   - frame:          The size of UIImageView.
    ///   - cornerRadius:   The cornerRadius of UIImageView.
    ///   - image:          The target image name.
    ///   - contentMode:    The ContentMode of UIImageView.
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
}

// MARK: - Instance Method
extension UIImageView {
    
    /// Set an image with resource name.
    ///
    /// - Parameter name: The target image name.
    func setImage(withImageName name: String?) {
        image = UIImage(named: name ?? "")
    }

    /// Set an image with url, a placeholder image, progress handler and completion handler.
    ///
    /// - Parameters:
    ///   - url:                The target image URL.
    ///   - placeholderImage:   A placeholder image when retrieving the image at URL.
    ///   - progressBlock:      Called when the image downloading progress gets updated.
    ///   - completionHandler:  Called when the image retrieved and set.
    func setImage(withURL url: String? = nil,
                  placeholderImage: String? = "avatar_placeholder",
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) {
        
        // use absoluteURL(without sign) as a key to cache the image resource
        guard let url = url, let URL = URL(string: url) else { println(#function); return }
        let splitArray = URL.absoluteString.components(separatedBy: "?")
        guard let pureURL = splitArray.first, !pureURL.isEmpty else { return }
        
        // setup the resource
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
