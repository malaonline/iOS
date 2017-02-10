//
//  Extension+UILabel.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

extension UILabel {
    
    ///  convenience to create a UILabel With textColor:#939393 and FontSize: 12
    ///
    ///  - returns: UILabel
    class func subTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(named: .HeaderTitle)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }
    
    convenience init(text: String = "", font: UIFont? = nil, fontSize: CGFloat? = nil, textColor: UIColor? = nil, textAlignment: NSTextAlignment = .left, backgroundColor: UIColor? = nil, opacity: CGFloat? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        self.init()
        self.text = text
        
        if let font = font {
            self.font = font
        }else if let fontSize = fontSize {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        
        self.textAlignment = textAlignment
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let opacity = opacity {
            self.alpha = opacity
        }
        
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
            
            if let borderWidth = borderWidth {
                self.layer.borderWidth = borderWidth
            }
        }
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
