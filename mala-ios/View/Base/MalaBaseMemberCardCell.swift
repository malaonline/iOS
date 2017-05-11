//
//  MalaBaseMemberCardCell.swift
//  mala-ios
//
//  Created by 王新宇 on 11/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MalaBaseMemberCardCell: UITableViewCell {

    // MARK: - Components
    /// 父布局容器（白色卡片）
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    
    // MARK: - Instance Method
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
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(content)
        
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.height.equalTo(266)
            maker.bottom.equalTo(contentView)
            
        }
        content.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentShadow)
            maker.size.equalTo(contentShadow)
        }
    }
}
