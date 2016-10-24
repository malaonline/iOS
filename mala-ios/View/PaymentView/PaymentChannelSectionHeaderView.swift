//
//  PaymentChannelSectionHeaderView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class PaymentChannelSectionHeaderView: UIView {
    
    // MARK: - Components
    /// Section标题
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = MalaColor_6C6C6C_0
        titleLabel.text = "选择支付方式"
        return titleLabel
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.clear
        
        // SubViews
        addSubview(titleLabel)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self).offset(12)
            maker.top.equalTo(self).offset(10)
            maker.bottom.equalTo(self).offset(-10)
            maker.height.equalTo(13)
        }
    }
}
