//
//  Extension+UILabel.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

extension UILabel {
    
    ///  convenience to create a UILabel with title
    ///
    ///  - parameter title: String for title
    ///
    ///  - returns: UILabel
    convenience init(title: String) {
        self.init()
        self.text = title
        self.sizeToFit()
    }
    
    ///  convenience to create a UILabel With textColor:#939393 and FontSize: 12
    ///
    ///  - returns: UILabel
    class func subTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = MalaDetailsCellSubTitleColor
        label.font = UIFont.systemFontOfSize(MalaLayout_FontSize_14)
        label.textAlignment = .Center
        return label
    }
    
}