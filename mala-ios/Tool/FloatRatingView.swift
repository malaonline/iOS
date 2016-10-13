//
//  FloatRatingView.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

@objc public protocol FloatRatingViewDelegate {
    /**
    Returns the rating value when touch events end
    */
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    
    /**
    Returns the rating value as the user pans
    */
    @objc optional func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float)
}

/**
A simple rating view that can set whole, half or floating point ratings.
*/
@IBDesignable
open class FloatRatingView: UIView {
    
    // MARK: Float Rating View properties
    
    open weak var delegate: FloatRatingViewDelegate?
    
    /**
    Array of empty image views
    */
    private var emptyImageViews: [UIImageView] = []
    
    /**
    Array of full image views
    */
    private var fullImageViews: [UIImageView] = []

    /**
    Sets the empty image (e.g. a star outline)
    */
    @IBInspectable open var emptyImage: UIImage? {
        didSet {
            // Update empty image views
            for imageView in self.emptyImageViews {
                imageView.image = emptyImage
            }
            self.refresh()
        }
    }
    
    /**
    Sets the full image that is overlayed on top of the empty image.
    Should be same size and shape as the empty image.
    */
    @IBInspectable open var fullImage: UIImage? {
        didSet {
            // Update full image views
            for imageView in self.fullImageViews {
                imageView.image = fullImage
            }
            self.refresh()
        }
    }
    
    /**
    Sets the empty and full image view content mode.
    */
    var imageContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit
    
    /**
    Minimum rating.
    */
    @IBInspectable open var minRating: Int  = 0 {
        didSet {
            // Update current rating if needed
            if self.rating < Float(minRating) {
                self.rating = Float(minRating)
                self.refresh()
            }
        }
    }
    
    /**
    Max rating value.
    */
    @IBInspectable open var maxRating: Int = 5 {
        didSet {
            let needsRefresh = maxRating != oldValue
            
            if needsRefresh {
                self.removeImageViews()
                self.initImageViews()
                
                // Relayout and refresh
                self.setNeedsLayout()
                self.refresh()
            }
        }
    }
    
    /**
    Minimum image size.
    */
    @IBInspectable open var minImageSize: CGSize = CGSize(width: 5.0, height: 5.0)
    
    /**
    Set the current rating.
    */
    @IBInspectable open var rating: Float = 0 {
        didSet {
            if rating != oldValue {
                self.refresh()
            }
        }
    }
    
    /**
    Sets whether or not the rating view can be changed by panning.
    */
    @IBInspectable open var editable: Bool = true
    
    /**
    Ratings change by 0.5. Takes priority over floatRatings property.
    */
    @IBInspectable open var halfRatings: Bool = false
    
    /**
    Ratings change by floating point values.
    */
    @IBInspectable open var floatRatings: Bool = false
    
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImageViews()
        self.setupUserInterface()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initImageViews()
    }
    
    private func setupUserInterface() {
        
        // Required float rating view params
        self.emptyImage = UIImage(named: "starEmpty")
        self.fullImage = UIImage(named: "starFull")
        
        // Optional params
        self.contentMode = UIViewContentMode.scaleAspectFit
        self.maxRating = 5
        self.minRating = 1
        self.rating = 0.0
        self.editable = true
        self.halfRatings = false
        self.floatRatings = false
    }
    
    // MARK: Refresh hides or shows full images
    
    func refresh() {
        for i in 0..<self.fullImageViews.count {
            let imageView = self.fullImageViews[i]
            
            if self.rating>=Float(i+1) {
                imageView.layer.mask = nil
                imageView.isHidden = false
            }
            else if self.rating>Float(i) && self.rating<Float(i+1) {
                // Set mask layer for full image
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(self.rating-Float(i))*imageView.frame.size.width, height: imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                imageView.layer.mask = maskLayer
                imageView.isHidden = false
            }
            else {
                imageView.layer.mask = nil;
                imageView.isHidden = true
            }
        }
    }
    
    // MARK: Layout helper classes
    
    // Calculates the ideal ImageView size in a given CGSize
    func sizeForImage(_ image: UIImage, inSize size:CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSize(width: width, height: size.height)
        }
        else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSize(width: size.width, height: height)
        }
    }
    
    // Override to calculate ImageView frames
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let emptyImage = self.emptyImage {
            let desiredImageWidth = self.frame.size.width / CGFloat(self.emptyImageViews.count)
            let maxImageWidth = max(self.minImageSize.width, desiredImageWidth)
            let maxImageHeight = max(self.minImageSize.height, self.frame.size.height)
            let imageViewSize = self.sizeForImage(emptyImage, inSize: CGSize(width: maxImageWidth, height: maxImageHeight))
            let imageXOffset = (self.frame.size.width - (imageViewSize.width * CGFloat(self.emptyImageViews.count))) /
                                CGFloat((self.emptyImageViews.count - 1))
            
            for i in 0..<self.maxRating {
                let imageFrame = CGRect(x: i==0 ? 0:CGFloat(i)*(imageXOffset+imageViewSize.width), y: 0, width: imageViewSize.width, height: imageViewSize.height)
                
                var imageView = self.emptyImageViews[i]
                imageView.frame = imageFrame
                
                imageView = self.fullImageViews[i]
                imageView.frame = imageFrame
            }
            
            self.refresh()
        }
    }
    
    func removeImageViews() {
        // Remove old image views
        for i in 0..<self.emptyImageViews.count {
            var imageView = self.emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = self.fullImageViews[i]
            imageView.removeFromSuperview()
        }
        self.emptyImageViews.removeAll(keepingCapacity: false)
        self.fullImageViews.removeAll(keepingCapacity: false)
    }
    
    func initImageViews() {
        if self.emptyImageViews.count != 0 {
            return
        }
        
        // Add new image views
        for _ in 0..<self.maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = self.imageContentMode
            emptyImageView.image = self.emptyImage
            self.emptyImageViews.append(emptyImageView)
            self.addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = self.imageContentMode
            fullImageView.image = self.fullImage
            self.fullImageViews.append(fullImageView)
            self.addSubview(fullImageView)
        }
    }
    
    // MARK: Touch events
    
    // Calculates new rating based on touch location in view
    func handleTouchAtLocation(_ touchLocation: CGPoint) {
        if !self.editable {
            return
        }
        
        var newRating: Float = 0
        for i in stride(from: (self.maxRating-1), through: 0, by: -1) {
            let imageView = self.emptyImageViews[i]
            if touchLocation.x > imageView.frame.origin.x {
                // Find touch point in image view
                let newLocation = imageView.convert(touchLocation, from:self)
                
                // Find decimal value for float or half rating
                if imageView.point(inside: newLocation, with: nil) && (self.floatRatings || self.halfRatings) {
                    let decimalNum = Float(newLocation.x / imageView.frame.size.width)
                    newRating = Float(i) + decimalNum
                    if self.halfRatings {
                        newRating = Float(i) + (decimalNum > 0.75 ? 1:(decimalNum > 0.25 ? 0.5:0))
                    }
                }
                // Whole rating
                else {
                    newRating = Float(i) + 1.0
                }
                break
            }
        }
        
        // Check min rating
        self.rating = newRating < Float(self.minRating) ? Float(self.minRating):newRating
        
        // Update delegate
        if let delegate = self.delegate {
            delegate.floatRatingView?(self, isUpdating: self.rating)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            let touchLocation = touch.location(in: self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Update delegate
        if let delegate = self.delegate {
            delegate.floatRatingView(self, didUpdate: self.rating)
        }
    }
    
}
