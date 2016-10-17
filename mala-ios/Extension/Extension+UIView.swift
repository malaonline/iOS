//
//  Extension+UIView.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

extension UIView {

    ///  convenience to create a view with background color
    ///
    ///  - returns: UIView
    convenience init(_ backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}
