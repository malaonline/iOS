//
//  Extension+UIImage.swift
//  mala-ios
//
//  Created by Elors on 12/22/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

extension UIImage {
    
    ///  Create a UIImage From UIColor
    ///
    ///  - parameter color: UIImage's Color
    ///
    ///  - returns: UIImage
    class func withColor(_ color: UIColor = UIColor.white, bounds: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
        
        let rect = bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func largestCenteredSquareImage() -> UIImage {
        let scale = self.scale
        
        let originalWidth  = self.size.width * scale
        let originalHeight = self.size.height * scale
        
        let edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        if let cgImage = self.cgImage, let imageRef = cgImage.cropping(to: cropSquare) {
            return UIImage(cgImage: imageRef, scale: scale, orientation: self.imageOrientation)
        }else {
            return self
        }
    }
    
    func resizeToTargetSize(_ targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scale = UIScreen.main.scale
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: scale * floor(size.width * heightRatio), height: scale * floor(size.height * heightRatio))
        } else {
            newSize = CGSize(width: scale * floor(size.width * widthRatio), height: scale * floor(size.height * widthRatio))
        }
        
        let rect = CGRect(x: 0, y: 0, width: floor(newSize.width), height: floor(newSize.height))
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        }else {
            return self
        }
    }
}
