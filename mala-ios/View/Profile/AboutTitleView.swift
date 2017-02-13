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
        let titleLabel = UILabel(
            fontSize: 14,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return titleLabel
    }()
    /// 左侧装饰线
    private var leftLine: UIImageView = {
        let leftLine = UIImageView(imageName: "titleLeftLine")
        return leftLine
    }()
    /// 右侧装饰线
    private var rightLine: UIImageView = {
        let rightLine = UIImageView(imageName: "titleRightLine")
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
            maker.top.equalTo(self)
            maker.centerX.equalTo(self)
            maker.height.equalTo(14)
            maker.bottom.equalTo(self)
        }
        leftLine.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(titleLabel)
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(titleLabel.snp.left).offset(-5)
        }
        rightLine.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(titleLabel)
            maker.left.equalTo(titleLabel.snp.right).offset(5)
            maker.right.equalTo(self).offset(-10)
        }
    }
}
