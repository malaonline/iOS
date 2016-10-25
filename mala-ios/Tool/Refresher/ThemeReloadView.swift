//
//  ThemeReloadView.swift
//  mala-ios
//
//  Created by 王新宇 on 3/12/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class ThemeReloadView: UITableViewCell {
    
    // MARK: - Components
    /// 加载指示器
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        // SubViews
        addSubview(activityIndicator)
        
        // Autolayout
        activityIndicator.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(self)
        }
    }
}
