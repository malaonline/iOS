//
//  Extension+UIView.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

extension UIView {

    ///  convenience to create a separator line view
    ///
    ///  - returns: UIView
    class func separator(_ color: UIColor = UIColor.black) -> UIView {
        let separatorLine = UIView()
        separatorLine.backgroundColor = color
        return separatorLine
    }
    
    class func line(_ color: UIColor = UIColor.black) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        return line
    }
}
