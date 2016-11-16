//
//  BaseWindow.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/16.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class BaseWindow: UIWindow {
    
    // MARK: - Property
    override var rootViewController: UIViewController? {
        didSet {
            // 自动覆盖根控制器
            if let viewController = rootViewController as? MainViewController {
                MalaMainViewController = viewController
            }
        }
    }
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
