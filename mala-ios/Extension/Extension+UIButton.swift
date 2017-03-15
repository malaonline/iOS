//
//  Extension+UIButton.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

// MARK: - Class Method
extension UIButton {
    
    /// Exchange the position between image and label.
    ///
    /// - Parameter padding: padding
    func exchangeImageAndLabel(_ padding: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel!.frame.width + padding, bottom: 0, right: -titleLabel!.frame.width + padding)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView!.frame.width, bottom: 0, right: imageView!.frame.width)
    }
}


// MARK: - Convenience
extension UIButton {
    
    /// Convenience Function to Create UIButton
    /// (Usually Use For UIBarButtonItem)
    ///
    /// - Parameters:
    ///   - title:              String for title.
    ///   - imageName:          String for image name.
    ///   - highlightImageName: String for image name in highlight status.
    ///   - target:             Handler of action.
    ///   - action:             Action when button did tap.
    convenience init(title: String? = nil, imageName: String? = nil, highlightImageName: String? = nil, target: AnyObject? = nil, action:Selector) {
        self.init()
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitle(title, for: .normal)
        setTitleColor(UIColor(named: .ArticleSubTitle), for: .normal)
        if imageName != nil {
            setImage(UIImage(named: imageName!), for: .normal)
        }
        if highlightImageName != nil {
            setImage(UIImage(named: highlightImageName!), for: .highlighted)
        }
        addTarget(target, action: action, for: .touchUpInside)
        sizeToFit()
    }
    
    /// Convenience to Create UIButton With TitleColor and BackgroundColor
    ///
    /// - Parameters:
    ///   - title:              String for title.
    ///   - titleColor:         Color for titleColor in normal status
    ///   - selectedTitleColor: Color for titleColor in selected status
    ///   - bgColor:            Color for background color in normal status
    ///   - selectedBgColor:    Color for background color in selected status
    convenience init(title: String, titleColor: UIColor? = nil, selectedTitleColor: UIColor? = nil, bgColor: UIColor = UIColor.white, selectedBgColor: UIColor = UIColor.white) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(selectedTitleColor, for: .selected)
        setBackgroundImage(UIImage.withColor(bgColor), for: .normal)
        setBackgroundImage(UIImage.withColor(selectedBgColor), for: .selected)
        sizeToFit()
    }
    
    /// Convenience to create button with title, titleColor and background color
    /// FontSize is default to 16
    ///
    /// - Parameters:
    ///   - title:              String for title.
    ///   - titleColor:         Color for title.
    ///   - backgroundColor:    Color for background.
    convenience init(title: String, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        sizeToFit()
    }
    
    /// Convenience to create a fillet button with title and color.
    ///
    /// - Parameters:
    ///   - title:          String of title.
    ///   - borderColor:    Color for border in normal status, background in highlighted status.
    ///   - target:         Handler of action.
    ///   - action:         Action when button did tap.
    ///   - borderWidth:    Width of border.
    convenience init(title: String, borderColor: UIColor, target: AnyObject?, action: Selector? = nil, borderWidth: CGFloat = MalaScreenOnePixel) {
        self.init()
        // title and color
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.setTitle(title, for: .normal)
        self.setTitleColor(borderColor, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .selected)
        // background color
        self.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        self.setBackgroundImage(UIImage.withColor(borderColor), for: .highlighted)
        self.setBackgroundImage(UIImage.withColor(borderColor), for: .selected)
        // fillet and border
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        // action
        if let selector = action {
            self.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
    
    /// Convenience to create a button with title, color and action.
    ///
    /// - Parameters:
    ///   - title:      String for title.
    ///   - titleColor: Color for title string.
    ///   - target:     Handler of action.
    ///   - action:     Action when button did tap.
    convenience init(title: String, titleColor: UIColor, target: AnyObject?, action: Selector) {
        self.init()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.sizeToFit()
    }
}
