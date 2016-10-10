//
//  SKPhoto.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

public protocol SKPhotoProtocol: NSObjectProtocol {
    var underlyingImage: UIImage! { get }
    var caption: String! { get }
    var index: Int? { get set}
    func loadUnderlyingImageAndNotify()
    func checkCache()
}

// MARK: - SKPhoto
open class SKPhoto: NSObject, SKPhotoProtocol {
    
    open var underlyingImage: UIImage!
    open var photoURL: String!
    open var shouldCachePhotoURLImage: Bool = false
    open var caption: String!
    open var index: Int?

    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
    }
    
    convenience init(url: String) {
        self.init()
        photoURL = url
    }
    
    open func checkCache() {
        if photoURL != nil && shouldCachePhotoURLImage {
            if let img = UIImage.sharedSKPhotoCache().object(forKey: photoURL as AnyObject) as? UIImage {
                underlyingImage = img
            }
        }
    }
    
    open func loadUnderlyingImageAndNotify() {
        if underlyingImage != nil {
            loadUnderlyingImageComplete()
        }
        
        if photoURL != nil {
            // Fetch Image
            let session = URLSession(configuration: URLSessionConfiguration.default)
            if let nsURL = URL(string: photoURL) {
                session.dataTask(with: nsURL, completionHandler: { [weak self](response: Data?, data: URLResponse?, error: NSError?) in
                    if let _self = self {
                        if error != nil {
                            DispatchQueue.main.asynchronously(DispatchQueue.main) {
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        if let res = response, let image = UIImage(data: res) {
                            if _self.shouldCachePhotoURLImage {
                                UIImage.sharedSKPhotoCache().setObject(image, forKey: _self.photoURL as AnyObject)
                            }
                            DispatchQueue.main.asynchronously(DispatchQueue.main) {
                                _self.underlyingImage = image
                                _self.loadUnderlyingImageComplete()
                            }
                        }
                        session.finishTasksAndInvalidate()
                    }
                } as! (Data?, URLResponse?, Error?) -> Void).resume()
            }
        }
    }

    open func loadUnderlyingImageComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SKPHOTO_LOADING_DID_END_NOTIFICATION), object: self)
    }
    
    // MARK: - class func
    open class func photoWithImage(_ image: UIImage) -> SKPhoto {
        return SKPhoto(image: image)
    }
    open class func photoWithImageURL(_ url: String) -> SKPhoto {
        return SKPhoto(url: url)
    }
}

// MARK: - extension UIImage
public extension UIImage {
    fileprivate class func sharedSKPhotoCache() -> NSCache<AnyObject, AnyObject>! {
        struct StaticSharedSKPhotoCache {
            static var sharedCache: NSCache? = nil
            static var onceToken: Int = 0
        }
        dispatch_once(&StaticSharedSKPhotoCache.onceToken) {
            StaticSharedSKPhotoCache.sharedCache = NSCache()
        }
        return StaticSharedSKPhotoCache.sharedCache!
    }
}
