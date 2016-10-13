//
//  AboutTitleView.swift
//  mala-ios
//
//  Created by 王新宇 on 3/15/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class AboutTitleView: UIView {
    
    // MARK: - Property
    /// 标题文字
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    

    // MARK: - Components
    /// 标题
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = MalaColor_6C6C6C_0
        return titleLabel
    }()
    /// 左侧装饰线
    private var leftLine: UIImageView = {
        let leftLine = UIImageView(image: UIImage(named: "titleLeftLine"))
        return leftLine
    }()
    /// 右侧装饰线
    private var rightLine: UIImageView = {
        let rightLine = UIImageView(image: UIImage(named: "titleRightLine"))
        return rightLine
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // SubViews
        addSubview(titleLabel)
        addSubview(leftLine)
        addSubview(rightLine)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self.snp.centerX)
            maker.top.equalTo(self.snp.top)
            maker.bottom.equalTo(self.snp.bottom)
            maker.height.equalTo(14)
        }
        leftLine.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(titleLabel.snp.centerY)
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(titleLabel.snp.left).offset(-5)
        }
        rightLine.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(titleLabel.snp.centerY)
            maker.left.equalTo(titleLabel.snp.right).offset(5)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
    }
}
