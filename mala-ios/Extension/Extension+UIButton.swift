//
//  Extension+UIButton.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

extension UIButton {
    
     ///  Convenience Function to Create UIButton
     ///  (Usually Use For UIBarButtonItem)
     ///
     ///  - parameter title:     String for Title
     ///  - parameter imageName: String for ImageName
     ///  - parameter target:    Object for Event's Target
     ///  - parameter action:    SEL for Event's Action
     ///
     ///  - returns: UIButton
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
    
    ///  Convenience Function to Create UIButton With TitleColor and BackgroundColor
    ///
    ///  - parameter title:              String for Title
    ///  - parameter titleColor:         UIColor for TitleColor in NormalState
    ///  - parameter selectedTitleColor: UIColor for TitleColor in SelectedState
    ///  - parameter bgColor:            UIColor for BackgroundColor in NormalState
    ///  - parameter selectedBgColor:    UIColor for BackgroundColor in SelectedState
    ///
    ///  - returns: UIButton
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
    
    ///  Convenience to Create UIButton With Title, TitleColor and BackgroundColor
    ///  FontSize is Default to 16
    ///  
    ///  - parameter title:           String for Title
    ///  - parameter titleColor:      UIColor for TitleColor
    ///  - parameter backgroundColor: UIColor for BackgroundColor
    ///
    ///  - returns: UIButton
    convenience init(title: String, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        sizeToFit()
    }
    
    func exchangeImageAndLabel(_ padding: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel!.frame.width + padding, bottom: 0, right: -titleLabel!.frame.width + padding)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView!.frame.width, bottom: 0, right: imageView!.frame.width)
    }
    
    ///  便利构造函数
    ///
    ///  - parameter title:       标题
    ///  - parameter borderColor: Normal状态边框颜色，Highlighted状态背景颜色
    ///
    ///  - returns: UIButton对象
    convenience init(title: String, borderColor: UIColor, target: AnyObject?, action: Selector? = nil, borderWidth: CGFloat = MalaScreenOnePixel) {
        self.init()
        // 文字及其状态颜色
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.setTitle(title, for: .normal)
        self.setTitleColor(borderColor, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .selected)
        // 背景状态颜色
        self.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        self.setBackgroundImage(UIImage.withColor(borderColor), for: .highlighted)
        self.setBackgroundImage(UIImage.withColor(borderColor), for: .selected)
        // 圆角和边框
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        if let selector = action {
            self.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
    
    ///  便利构造函数
    ///
    ///  - parameter title:      标题文字
    ///  - parameter titleColor: 标题文字颜色
    ///  - parameter target:     点击事件Handler
    ///  - parameter action:     点击事件Action
    ///
    ///  - returns: UIButton对象
    convenience init(title: String, titleColor: UIColor, target: AnyObject?, action: Selector) {
        self.init()
        // 文字及其状态颜色
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .highlighted)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.sizeToFit()
    }
}
